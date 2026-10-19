"""Real Bluetooth: the PC's Bluetooth radio plays the head unit's Bluetooth chip for audio.

- Pairing (Phone > Settings > Add Device): the HMI asks for discoverable mode (BluetoothGAP.setAccessMode
  GENERAL); the PC becomes discoverable and this module answers Windows' pairing requests itself
  (BluetoothRegisterForAuthenticationEx), so the phone's 6-digit code shows on the HMI's own PIN screen and
  its Yes/No goes back to the phone.
- Audio: a paired phone that can stream (A2DP source) is listed among the HMI's paired phones; connecting its
  Bluetooth audio opens Windows' A2DP sink (Windows.Media.Audio.AudioPlaybackConnection), so the phone plays
  through the PC's speakers.
- Track info and play/pause/next/previous come from the phone's media session (AVRCP) when Windows exposes
  one (GlobalSystemMediaTransportControlsSessionManager).

Calls/phonebook (HFP/PBAP) stay simulated: Windows does not let apps act as a hands-free car kit.
Needs the `winrt-*` packages (see README); without them this module stays off.
"""
import asyncio, ctypes, re, threading, time
from ctypes import wintypes
import handlers as H
from handlers import on

try:
    from winrt.windows.media.audio import AudioPlaybackConnection, AudioPlaybackConnectionOpenResultStatus
    from winrt.windows.devices.enumeration import DeviceInformation
    from winrt.windows.devices.bluetooth import BluetoothDevice
    from winrt.windows.media.control import GlobalSystemMediaTransportControlsSessionManager as SessionManager
    AVAILABLE = True
except ImportError:  # shortcut: no winrt -> no real Bluetooth, the simulated phones still work
    AVAILABLE = False

LOOP = asyncio.new_event_loop()
STATE = {"phones": {}, "conn": None, "addr": None, "pairing": None, "session": None, "logged_sessions": False}
TRACK = {"title": "", "artist": "", "album": "", "duration": 0, "time": 0, "playing": False}


def log(text):
    H.B.log("BT", text)


def run(coro, timeout=20):
    """Run a WinRT coroutine on the Bluetooth thread's loop and wait for it."""
    return asyncio.run_coroutine_threadsafe(coro, LOOP).result(timeout)


def fmt_addr(n):
    s = f"{n:012X}"
    return ":".join(s[i:i + 2] for i in range(0, 12, 2))


# ---------------------------------------------------------------- Win32 pairing (bthprops.cpl)
class BLUETOOTH_DEVICE_INFO(ctypes.Structure):
    _fields_ = [("dwSize", wintypes.DWORD), ("Address", ctypes.c_ulonglong), ("ulClassofDevice", wintypes.ULONG),
                ("fConnected", wintypes.BOOL), ("fRemembered", wintypes.BOOL), ("fAuthenticated", wintypes.BOOL),
                ("stLastSeen", wintypes.WORD * 8), ("stLastUsed", wintypes.WORD * 8), ("szName", wintypes.WCHAR * 248)]


class AUTH_PARAMS(ctypes.Structure):  # BLUETOOTH_AUTHENTICATION_CALLBACK_PARAMS
    _fields_ = [("deviceInfo", BLUETOOTH_DEVICE_INFO), ("authenticationMethod", ctypes.c_int),
                ("ioCapability", ctypes.c_int), ("authenticationRequirements", ctypes.c_int),
                ("value", wintypes.ULONG)]  # Numeric_Value / Passkey


class AUTH_RESPONSE(ctypes.Structure):  # BLUETOOTH_AUTHENTICATE_RESPONSE
    _fields_ = [("bthAddressRemote", ctypes.c_ulonglong), ("authMethod", ctypes.c_int),
                ("info", ctypes.c_ubyte * 32), ("negativeResponse", ctypes.c_ubyte)]


class GUID(ctypes.Structure):
    _fields_ = [("d1", ctypes.c_ulong), ("d2", ctypes.c_ushort), ("d3", ctypes.c_ushort), ("d4", ctypes.c_ubyte * 8)]


def _guid(short):  # Bluetooth base UUID with a 16-bit service id
    g = GUID(short, 0x0000, 0x1000)
    g.d4[:] = [0x80, 0x00, 0x00, 0x80, 0x5F, 0x9B, 0x34, 0xFB]
    return g


A2DP_SOURCE, AVRCP_TARGET, AVRCP = 0x110A, 0x110C, 0x110E
LEGACY, OOB, NUMERIC, PASSKEY_NOTIFY, PASSKEY = 1, 2, 3, 4, 5
AUTH_CB = ctypes.WINFUNCTYPE(wintypes.BOOL, ctypes.c_void_p, ctypes.POINTER(AUTH_PARAMS))
try:
    bth = ctypes.WinDLL("bthprops.cpl")  # Bluetooth pairing/discovery API
except OSError:  # no Bluetooth stack: pairing from the HMI is off, already-paired phones still work
    bth = None


def _respond(pending, accept):
    r = AUTH_RESPONSE(bthAddressRemote=pending["addr"], authMethod=pending["method"], negativeResponse=0 if accept else 1)
    if pending["method"] == LEGACY:
        pin = pending.get("pin", "0000").encode()
        r.info[:len(pin)] = list(pin)
        r.info[16] = len(pin)
    elif pending["method"] in (NUMERIC, PASSKEY, PASSKEY_NOTIFY):
        ctypes.memmove(ctypes.addressof(r.info), ctypes.byref(wintypes.ULONG(pending["value"])), 4)
    err = bth.BluetoothSendAuthenticationResponseEx(None, ctypes.byref(r))
    log(f"pairing response accept={accept} method={pending['method']} -> {err}")
    return err == 0


def _on_auth(_ctx, params):
    try:
        return _handle_auth(params)
    except Exception as e:  # an exception here would fail the phone's authentication (Windows then drops the key)
        log(f"pairing callback error: {e!r}")
        return False


def _handle_auth(params):
    p = params.contents
    addr, name = p.deviceInfo.Address, p.deviceInfo.szName
    pending = {"addr": addr, "method": p.authenticationMethod, "value": p.value, "name": name, "t": time.time()}
    STATE["pairing"] = pending
    log(f"pairing request from {name} {fmt_addr(addr)} method={p.authenticationMethod} value={p.value}")
    if p.authenticationMethod in (NUMERIC, PASSKEY_NOTIFY):
        # the HMI's own "Confirm the PIN on your phone" screen; its Yes/No comes back as securePairingReply
        H.B.send("BluetoothGAP", {"securePairingRequest": {"address": fmt_addr(addr), "pin": f"{p.value:06d}",
                                                            "name": name}})
    else:  # legacy PIN / passkey entry: the HMI shows its fixed PIN (passkey property) and auto-accepts
        pending["pin"] = "1234"
        H.B.send("BluetoothGAP", {"standardPairingRequest": {"address": fmt_addr(addr), "name": name}})
    threading.Thread(target=_await_paired, args=(addr,), daemon=True).start()
    return True


_auth_cb = AUTH_CB(_on_auth)  # module-level: Windows keeps calling it
_auth_handle = wintypes.HANDLE()


_repaired = set()


def ensure_audio_service(addr_int):
    """A phone paired from its own side (iPhone Settings > Bluetooth) sometimes gets no audio service installed
    in Windows: only the bare device, so it cannot stream ("Connection Unsuccessful" on the iPhone). Turning the
    phone's A2DP-source and AVRCP services on installs them. Phones only (class of device major 2)."""
    if not bth or addr_int in _repaired:
        return
    _repaired.add(addr_int)
    d = BLUETOOTH_DEVICE_INFO(dwSize=ctypes.sizeof(BLUETOOTH_DEVICE_INFO), Address=addr_int)
    if bth.BluetoothGetDeviceInfo(None, ctypes.byref(d)) or (d.ulClassofDevice >> 8) & 0x1F != 2:
        return
    res = [bth.BluetoothSetServiceState(None, ctypes.byref(d), ctypes.byref(_guid(u)), 1)
           for u in (A2DP_SOURCE, AVRCP_TARGET, AVRCP)]
    log(f"enabled audio services for {d.szName} -> {res}")


def set_discoverable(on):
    if not bth:
        return
    # Windows sends every authentication to a registered callback, also an already-paired phone reconnecting;
    # so it is only registered while the HMI's pairing screen is up (fresh each time: a radio reset drops it).
    if _auth_handle.value:
        bth.BluetoothUnregisterAuthentication(_auth_handle)
        _auth_handle.value = None
    if on:
        err = bth.BluetoothRegisterForAuthenticationEx(None, ctypes.byref(_auth_handle), _auth_cb, None)
        log(f"pairing callback registered -> {err}")
    bth.BluetoothEnableIncomingConnections(None, True)
    ok = bth.BluetoothEnableDiscovery(None, bool(on))
    log(f"discoverable={on} -> {ok}")


@on("BluetoothGAP", "setAccessMode")
def gap_access_mode(dest, args, conn):
    H.B.send("BluetoothGAP", {"setAccessMode": {"description": "success", "code": 0}}, conn)
    if AVAILABLE:
        set_discoverable(args.get("accessMode") == "GENERAL")


@on("BluetoothGAP", "securePairingReply")
@on("BluetoothGAP", "standardPairingReply")
def gap_pairing_reply(dest, args, conn):
    pending = STATE["pairing"]
    if pending and args.get("address", "").upper() == fmt_addr(pending["addr"]):
        _respond(pending, args.get("accept") in (True, "true"))
    for c in ("securePairingReply", "standardPairingReply"):
        H.B.send("BluetoothGAP", {c: {"description": "success", "code": 0}}, conn)


def _await_paired(addr):
    """Windows finishes pairing (and installs the audio profile) on its own; report it once the phone is there."""
    for _ in range(60):
        time.sleep(1)
        if fmt_addr(addr) in STATE["phones"]:  # _watch_pairings already picked it up
            return
        refresh()
        if fmt_addr(addr) in STATE["phones"]:
            p = STATE["phones"][fmt_addr(addr)]
            log(f"paired {p['name']}")
            H.B.send("BluetoothGAP", {"pairingStatus": {"address": p["address"], "pairStatus": "success",
                                                        "name": p["name"]}})
            H.B.send("BluetoothGAP", {"pairingStatus": {"address": p["address"], "pairStatus": "complete",
                                                        "name": p["name"]}})
            set_discoverable(False)
            _phone_mod().real_phones_changed()
            return
    log("pairing did not finish in 60 s")
    H.B.send("BluetoothGAP", {"pairingStatus": {"address": fmt_addr(addr), "pairStatus": "failed"}})


# ---------------------------------------------------------------- WinRT: paired phones, A2DP sink
# ...BTHENUM#{0000110a-...}_VID&0001004c_PID&7808#9&27dabf5&0&A1B2C3D4E5F6_C00000000#{...}\SNK
ADDR_RE = re.compile(r"&([0-9a-fA-F]{12})_C[0-9a-fA-F]+#")


PAIRED_RE = re.compile(r"-((?:[0-9a-f]{2}:){5}[0-9a-f]{2})$", re.I)  # Bluetooth#Bluetooth<radio>-<phone>


async def _scan():
    """Phones paired with Windows that can stream audio. Windows hides a phone from the audio-source list
    while its stream is open, so a known phone stays listed for as long as it is still paired."""
    paired = {m.group(1).upper() for d in await DeviceInformation.find_all_async_aqs_filter(
        BluetoothDevice.get_device_selector_from_pairing_state(True)) if (m := PAIRED_RE.search(d.id))}
    phones = {a: p for a, p in STATE["phones"].items() if a in paired}
    for d in await DeviceInformation.find_all_async_aqs_filter(AudioPlaybackConnection.get_device_selector()):
        m = ADDR_RE.search(d.id)
        addr = fmt_addr(int(m.group(1), 16)) if m else d.id
        phones[addr] = {"address": addr, "name": d.name, "id": d.id}
    for a in paired - set(phones):  # paired, but Windows installed no audio service for it
        ensure_audio_service(int(a.replace(":", ""), 16))
    return phones


def refresh():
    """Paired phones that can stream audio to this PC: {address: {address, name, id}}."""
    if not AVAILABLE:
        return {}
    try:
        STATE["phones"] = run(_scan())
    except Exception as e:  # radio unplugged etc.
        log(f"scan failed: {e!r}")
    return STATE["phones"]


async def _open(device_id):
    c = AudioPlaybackConnection.try_create_from_id(device_id)
    if c is None:
        return None, "unsupported"
    await c.start_async()
    r = await c.open_async()
    if r.status != AudioPlaybackConnectionOpenResultStatus.SUCCESS:
        c.close()
        return None, f"{r.status} {r.extended_error}"
    return c, "ok"


def connect(address):
    """Open the phone's audio stream (blocking, up to ~20 s). True when the phone is playing to the PC."""
    p = STATE["phones"].get(address) or refresh().get(address)
    if not p:
        return False
    disconnect()
    try:
        c, why = run(_open(p["id"]))
    except Exception as e:
        c, why = None, repr(e)
    log(f"A2DP connect {p['name']}: {why}")
    if c:
        STATE.update(conn=c, addr=address)
        c.add_state_changed(lambda sender, _a: LOOP.call_soon_threadsafe(_state_changed, sender))
    return c is not None


def _state_changed(sender):
    if sender is STATE["conn"] and int(sender.state) == 0:  # closed
        addr = STATE["addr"]
        STATE.update(conn=None, addr=None, session=None)
        log("A2DP closed by the phone")
        _phone_mod().real_audio_lost(addr)


def disconnect():
    c = STATE["conn"]
    STATE.update(conn=None, addr=None, session=None)
    TRACK.update(title="", artist="", album="", duration=0, time=0, playing=False)
    if c:
        try:
            c.close()
        except Exception:
            pass


async def _unpair(device_id):
    d = await BluetoothDevice.from_id_async(device_id)
    if d:
        await d.device_information.pairing.unpair_async()


def unpair(address):
    p = STATE["phones"].get(address)
    if address == STATE["addr"]:
        disconnect()
    if p:
        try:
            run(_unpair(p["id"]))
        except Exception as e:
            log(f"unpair failed: {e!r}")
    STATE["phones"].pop(address, None)


# ---------------------------------------------------------------- AVRCP via Windows media sessions
async def _poll_session():
    mgr = await SessionManager.request_async()
    sessions = list(mgr.get_sessions())
    ids = sorted(s.source_app_user_model_id for s in sessions)
    if ids != STATE["logged_sessions"]:  # which app Windows names the phone's AVRCP session after
        log("media sessions: " + ", ".join(ids))
        STATE["logged_sessions"] = ids
    # the phone's session: Windows names it after the A2DP connection, not after a PC app
    phone = STATE["phones"].get(STATE["addr"], {}).get("name", "~")
    s = next((s for s in sessions if any(k in s.source_app_user_model_id.lower() for k in
                                         ("bluetooth", "audioplaybackconnection", "bthavrcp", phone.lower()))), None)
    STATE["session"] = s
    if not s:
        return
    props = await s.try_get_media_properties_async()
    tl, pb = s.get_timeline_properties(), s.get_playback_info()
    TRACK.update(title=props.title or "", artist=props.artist or "", album=props.album_title or "",
                 duration=int(tl.end_time.total_seconds()) if tl.end_time else 0,
                 time=int(tl.position.total_seconds()) if tl.position else 0,
                 playing=int(pb.playback_status) == 4)  # GlobalSystemMediaTransportControlsSessionPlaybackStatus.PLAYING


def control(cmd):
    """play | pause | next | previous on the phone (AVRCP)."""
    s = STATE["session"]
    if not s:
        return False
    fn = {"play": s.try_play_async, "pause": s.try_pause_async, "next": s.try_skip_next_async,
          "previous": s.try_skip_previous_async}[cmd]
    try:
        return run(fn(), 5)
    except Exception as e:
        log(f"control {cmd}: {e!r}")
        return False


def _watch_pairings():
    """Phones paired through Windows itself (its own pairing pop-up, Settings) count too: pick them up."""
    known = set(STATE["phones"])
    new = set(refresh()) - known
    gone = known - set(STATE["phones"])
    if not (new or gone):
        return
    phone = _phone_mod()
    for addr in new:
        p = STATE["phones"][addr]
        log(f"new paired phone {p['name']} {addr}")
        if STATE["pairing"] is not None or bth and bth.BluetoothIsDiscoverable(None):  # HMI pairing screen is up
            for st in ("success", "complete"):
                H.B.send("BluetoothGAP", {"pairingStatus": {"address": addr, "pairStatus": st, "name": p["name"]}})
            set_discoverable(False)
    phone.real_phones_changed()
    if new and not streaming():
        phone.connect_real(next(iter(new)))


def streaming():
    """An audio connection that is actually open (a closed one can linger when its close event is missed)."""
    c = STATE["conn"]
    try:
        if c is not None and int(c.state) == 1:  # AudioPlaybackConnectionState: 0 closed, 1 opened
            return True
    except Exception:
        pass
    if c is not None:
        addr = STATE["addr"]
        disconnect()
        log("A2DP connection gone")
        _phone_mod().real_audio_lost(addr)
    return False


def _ticker():
    n = 0
    while True:
        time.sleep(1)
        n += 1
        if n % 5 == 0 and not streaming():  # no device scans while a phone streams: keep the radio for audio
            try:
                _watch_pairings()
            except Exception as e:
                log(f"pairing watch: {e!r}")
        if STATE["conn"]:
            try:
                before = dict(TRACK)
                run(_poll_session(), 5)
                if TRACK != before:
                    H.bt_remote_changed(before)
            except Exception as e:
                log(f"session poll: {e!r}")


def _phone_mod():
    from modules import phone
    return phone


def init(B):
    if not AVAILABLE:
        B.log("BT", "winrt packages missing: real Bluetooth audio off")
        return
    threading.Thread(target=LOOP.run_forever, daemon=True, name="bt-winrt").start()
    threading.Thread(target=_ticker, daemon=True, name="bt-avrcp").start()
