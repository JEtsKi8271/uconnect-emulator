"""Module-specific behaviour layered on backend.py's generic state machine.

Each @on(module, command) handler gets (dest, args, conn). Message shapes come from the
decompiled moduleLink classes in MainSupplement.swf (see schema.json for field paths).
"""
import json, os, struct, time

B = None  # backend module, set by init()
_pending = []


def on(module, command):
    def deco(fn):
        _pending.append((module, command, fn))
        return fn
    return deco


def init(backend):
    global B
    B = backend
    # Feature modules (modules/*.py) register @on handlers at import and may define init(B).
    import importlib, pkgutil, modules
    for info in pkgutil.iter_modules(modules.__path__):
        m = importlib.import_module(f"modules.{info.name}")
        if hasattr(m, "init"):
            m.init(B)
    for module, command, fn in _pending:
        B.HOOKS[(module, command)] = fn
    write_hmivars()
    t = B.mod("Tuner")
    t["presetList"], t["presetPositions"] = preset_list(), preset_positions()
    t["stationInfo"] = station_info("FM", TUNER["last"]["FM"])
    # USB stick is plugged in from boot (paused until the user picks the source).
    MEDIA["playing"] = False
    B.mod("Media").update(media_device_payloads())
    B.mod("Media").update(media_track_payloads())


# ---------------------------------------------------------------- hmiVars (boot config)
_INSTANCE = os.environ.get("UC_INSTANCE_DIR", os.path.dirname(os.path.abspath(__file__)))
CONFIG_FILE = os.path.join(_INSTANCE, "config.json")
HMIVARS_FILE = os.path.join(_INSTANCE, "hmi", "hmiVars")


def _fixed(text, size):
    return text.encode("utf-8")[:size].ljust(size, b"\0")


def write_hmivars():
    """Binary file Main.as reads at boot (readHMIVars): language, theme, skin, last screen,
    brand, region, nav flag, anti-theft, driver/comfort config, SRT, destination code."""
    c = json.load(open(CONFIG_FILE, encoding="utf-8"))
    data = (struct.pack("B", c["languageId"]) + _fixed(c["theme"], 50) + _fixed("default", 20)
            + _fixed(c["lastScreen"], 40) + struct.pack("BBB", c["brandId"], 1, 1 if c["navActivated"] else 0)
            + _fixed("unlocked", 10) + struct.pack("BBBB", 1, 7, 0, c["destinationCode"]) + b"\0")
    open(HMIVARS_FILE, "wb").write(data)


def update_config(**kv):
    c = json.load(open(CONFIG_FILE, encoding="utf-8"))
    c.update(kv)
    json.dump(c, open(CONFIG_FILE, "w", encoding="utf-8"), indent=1)
    write_hmivars()


@on("VehicleStatus", "setThemeTo")
def theme_to(dest, args, conn):
    update_config(theme=args["newTheme"])


def on_emit_signal(packet):
    var = packet.get("new_hmi_var")
    if var and var.get("key") == "last_screen":
        update_config(lastScreen=var["new_hmi_screen"])


# ---------------------------------------------------------------- Clock
def now_payload():
    t = time.localtime()
    return {"year": t.tm_year, "month": t.tm_mon, "day": t.tm_mday,
            "hour": t.tm_hour, "minute": t.tm_min, "second": t.tm_sec, "status": "ok"}


@on("Clock", "getTime")
def clock_get_time(dest, args, conn):
    B.send("Clock", {"getTime": now_payload()}, conn)


# ---------------------------------------------------------------- AntiTheft / power
@on("AntiTheft", "getAntiTheftState")
def antitheft_state(dest, args, conn):
    B.send("AntiTheft", {"antiTheftState": {"value": "unlocked"}}, conn)


@on("AntiTheft", "getProperties")
def antitheft_props(dest, args, conn):
    # Unlike the signals, getProperties carries raw values (AntiTheft.as).
    raw = {"ignState": "on", "powerModeState": "full_operation", "battConnect": "connected",
           "antiTheftLockTime": 0, "wakeupReason": "ignition"}
    B.send("AntiTheft", {"getProperties": {p: raw[p] for p in args.get("props", []) if p in raw}}, conn)


# ---------------------------------------------------------------- HVAC
HVAC = {
    "front": {"climate": "on", "ac": "on", "maxAC": "off", "auto": "off", "recirc": "off",
              "rearDefrost": "off", "sync": "off", "fan": "3", "airflowMode": "vent", "temp": "72"},
    "frontLeft": {"temp": "72"},
    "frontRight": {"temp": "72"},
}
FAN_STEPS = ["off", "1", "2", "3", "4", "5", "6", "7"]


def _temp_step(cur, delta):
    order = ["lo"] + [str(t) for t in range(60, 91)] + ["hi"]
    i = order.index(cur) if cur in order else order.index("72")
    return order[max(0, min(len(order) - 1, i + delta))]


def hvac_emit(zone, controls, conn=None):
    B.send("HVAC", {"zone": {"zone": zone, "controls": controls}}, conn)


@on("HVAC", "getZoneProperties")
def hvac_zones(dest, args, conn):
    zones = [{"zone": z, "controls": c} for z, c in HVAC.items()]
    B.send("HVAC", {"getZoneProperties": {"zones": zones}}, conn)


@on("HVAC", "getControlProperties")
def hvac_controls(dest, args, conn):
    z = args.get("zone", "front")
    cur = HVAC.get(z, {})
    wanted = args.get("controls") or list(cur)
    B.send("HVAC", {"getControlProperties": {"zone": z, "controls": {k: cur[k] for k in wanted if k in cur}}}, conn)


@on("HVAC", "setControlProperties")
def hvac_set(dest, args, conn):
    z = args.get("zone", "front")
    cur = HVAC.setdefault(z, {})
    changed = {}
    for k, v in args.get("controls", {}).items():
        if k in ("tempUp", "tempDown"):
            if v != "release":
                cur["temp"] = changed["temp"] = _temp_step(cur.get("temp", "72"), 1 if k == "tempUp" else -1)
        elif k in ("fanUp", "fanDown"):
            if v != "release":
                i = FAN_STEPS.index(cur.get("fan", "3")) if cur.get("fan") in FAN_STEPS else 3
                cur["fan"] = changed["fan"] = FAN_STEPS[max(0, min(7, i + (1 if k == "fanUp" else -1)))]
        else:
            cur[k] = changed[k] = v
    # Dual zone: driver temp change mirrors to passenger while sync is on.
    if "temp" in changed and z == "frontLeft" and HVAC["front"].get("sync") == "on":
        HVAC["frontRight"]["temp"] = changed["temp"]
        hvac_emit("frontRight", {"temp": changed["temp"]}, conn)
    if changed:
        hvac_emit(z, changed, conn)


# ---------------------------------------------------------------- Audio source
@on("Audio", "setAudioSource")
def audio_set_source(dest, args, conn):
    src = args.get("source", "fm")
    sig = {"source": src, "service": "hmi"}
    if src in DEVICES:
        sig[src] = {"id": DEVICES[src]["id"], "name": DEVICES[src]["name"]}
    B.mod("Audio")["audioSource"] = sig
    B.STATE["_replies"]["Audio"]["getAudioSource"] = {"source": src}
    B.send("Audio", {"audioSource": sig})
    if src in ("fm", "am"):
        tuner_tune(src.upper(), TUNER["last"][src.upper()])
    elif src in DEVICES:
        media_select_device(src)


@on("Audio", "setMute")
def audio_mute(dest, args, conn):
    state = args.get("state", args.get("mute", True))
    state = state in (True, "true", "on", "mute")
    B.mod("Audio")["userMuteState"] = {"state": state}
    B.send("Audio", {"userMuteState": {"state": state}})


# ---------------------------------------------------------------- Tuner (AM/FM)
# Frequencies in kHz, as the HMI expects (101100 -> "101.1").
STATIONS = {
    "FM": {88500: "KQED", 89300: "KPCC", 93100: "WXRT", 95500: "WPLJ", 97100: "KLOS",
           98700: "WFAN", 100300: "WHTZ", 101100: "WCBS", 102700: "KIIS", 104300: "WAXQ",
           105100: "WWPR", 106700: "KROQ"},
    "AM": {570: "KLAC", 660: "WFAN", 710: "WOR", 880: "WCBS", 1010: "WINS", 1130: "WBBR"},
}
BANDS = {"FM": (87900, 107900, 200), "AM": (530, 1710, 10)}
TUNER = {"band": "FM", "last": {"FM": 101100, "AM": 880}, "presets": {
    "FM": [88500, 93100, 95500, 98700, 101100, 102700, 104300, 106700, 0, 0, 0, 0],
    "AM": [570, 660, 710, 880, 1010, 1130, 0, 0, 0, 0, 0, 0]}}


def station_info(band, freq):
    return {"frequency": freq, "waveband": band, "senderName": STATIONS[band].get(freq, ""),
            "pi": 0, "rxQual": 5 if freq in STATIONS[band] else 1, "pty": ""}


def preset_obj(band, pos, freq):
    on_air = freq == TUNER["last"][band] and band == TUNER["band"]
    name = STATIONS[band].get(freq, "")
    # Carries both the PresetPersistencyManager and the Tuner field names. Positions are
    # 0-based; "Active" means the slot holds a station, "selected" means it is on air.
    return {"Position": pos, "Band": band.lower(), "Freq_Channel": freq, "SubChannel": 0,
            "StationName": name, "Genre": "", "Active": bool(freq), "EnsembID": [0, 0, 0], "PID": 0,
            "presetId": pos, "waveband": band, "frequency": freq, "senderName": name,
            "selected": "true" if on_air else "false", "pi": 0}


def preset_list():
    return {b.lower(): [preset_obj(b, i, f) for i, f in enumerate(fs)]
            for b, fs in TUNER["presets"].items()}


def preset_positions():
    pos = {}
    for b, fs in TUNER["presets"].items():
        cur = TUNER["last"][b]
        pos[b.lower()] = fs.index(cur) if cur in fs else 255
    return pos


def tuner_publish():
    t = B.mod("Tuner")
    t["presetList"] = preset_list()
    t["presetPositions"] = preset_positions()
    B.send("Tuner", {"presetList": t["presetList"]})
    B.send("Tuner", {"presetPositions": t["presetPositions"]})


def tuner_tune(band, freq):
    lo, hi, step = BANDS[band]
    freq = max(lo, min(hi, freq))
    TUNER["band"], TUNER["last"][band] = band, freq
    t = B.mod("Tuner")
    t["waveband"] = {"waveband": band}
    t["stationInfo"] = station_info(band, freq)
    B.send("Tuner", {"waveband": t["waveband"]})
    B.send("Tuner", {"stationInfo": t["stationInfo"]})
    tuner_publish()


def _next_station(band, freq, up):
    fs = sorted(STATIONS[band])
    cand = [f for f in fs if (f > freq if up else f < freq)]
    return (cand[0] if up else cand[-1]) if cand else (fs[0] if up else fs[-1])


@on("Tuner", "setWaveband")
def tuner_band(dest, args, conn):
    band = str(args.get("waveband", "FM")).upper()
    tuner_tune(band, TUNER["last"].get(band, BANDS[band][0]))


@on("Tuner", "setFrequency")
def tuner_freq(dest, args, conn):
    tuner_tune(TUNER["band"], int(args.get("frequency", TUNER["last"][TUNER["band"]])))


def _seek(seek_type):
    up = "UP" in seek_type.upper()
    B.send("Tuner", {"seekStatus": {"seekType": seek_type}})
    time.sleep(0.6)  # audible "searching" pause on the real unit
    tuner_tune(TUNER["band"], _next_station(TUNER["band"], TUNER["last"][TUNER["band"]], up))
    B.send("Tuner", {"seekStatus": {"seekType": "SEEK_STOP"}})


@on("Tuner", "seekPress")
def tuner_seek(dest, args, conn):
    import threading
    threading.Thread(target=_seek, args=(args.get("seekType", "SEEK_UP_AUTO"),), daemon=True).start()


@on("Tuner", "seekUpDown")
def tuner_step(dest, args, conn):
    # Manual tune one step (tune knob / tune screen arrows).
    band = TUNER["band"]
    v = args.get("seekUpDown", args.get("direction", args.get("value", 0)))
    up = v in (0, "0", "up", "UP")
    tuner_tune(band, TUNER["last"][band] + (BANDS[band][2] if up else -BANDS[band][2]))


@on("Tuner", "requestRecallPreset")
def tuner_recall(dest, args, conn):
    f = TUNER["presets"][TUNER["band"]][int(args["Position"])]
    if f:
        tuner_tune(TUNER["band"], f)


@on("Tuner", "requestStorePreset")
def tuner_store(dest, args, conn):
    band, pos = TUNER["band"], int(args["Position"])
    TUNER["presets"][band][pos] = TUNER["last"][band]
    data = preset_obj(band, pos, TUNER["last"][band])
    B.send("Tuner", {"presetUpdate": {"wb": band, "presetId": pos, "presetData": data}})
    tuner_publish()


@on("Tuner", "requestClearPreset")
def tuner_clear(dest, args, conn):
    TUNER["presets"][TUNER["band"]][int(args["Position"])] = 0
    tuner_publish()


@on("Tuner", "requestPresetPosition")
def tuner_preset_pos(dest, args, conn):
    B.send("Tuner", {"presetPositions": preset_positions()}, conn)


# ---------------------------------------------------------------- Media (USB / Bluetooth audio)
# Media source ids (msid) link Audio's source table to the Media service's devices.
DEVICES = {
    "usb1": {"id": 1, "name": "SANDISK 16GB", "type": "usb", "handle": 1},  # audio source "usb1", device type "usb"
    "btsa": {"id": 2, "name": "Pixel 8", "type": "btsa", "handle": 2},
}
LIBRARY = [  # (title, artist, album, genre, year, seconds)
    ("Highway Star", "Deep Purple", "Machine Head", "Rock", 1972, 365),
    ("Smoke on the Water", "Deep Purple", "Machine Head", "Rock", 1972, 340),
    ("Radar Love", "Golden Earring", "Moontan", "Rock", 1973, 383),
    ("Born to Be Wild", "Steppenwolf", "Steppenwolf", "Rock", 1968, 211),
    ("Life is a Highway", "Tom Cochrane", "Mad Mad World", "Rock", 1991, 266),
    ("Drive", "The Cars", "Heartbeat City", "Pop", 1984, 235),
    ("Little Red Corvette", "Prince", "1999", "Pop", 1982, 304),
    ("Mustang Sally", "Wilson Pickett", "The Wicked Pickett", "Soul", 1966, 183),
    ("Fast Car", "Tracy Chapman", "Tracy Chapman", "Folk", 1988, 296),
    ("Ramble On", "Led Zeppelin", "Led Zeppelin II", "Rock", 1969, 274),
    ("Running Down a Dream", "Tom Petty", "Full Moon Fever", "Rock", 1989, 263),
    ("Shut Up and Drive", "Rihanna", "Good Girl Gone Bad", "Pop", 2007, 212),
    ("Midnight City", "M83", "Hurry Up, We're Dreaming", "Electronic", 2011, 244),
    ("Nightcall", "Kavinsky", "OutRun", "Electronic", 2013, 258),
    ("Kickstart My Heart", "Motley Crue", "Dr. Feelgood", "Metal", 1989, 282),
]
MEDIA = {"device": "usb1", "track": 0, "time": 0, "playing": True, "repeat": "off", "random": "off"}


def _msid():
    return DEVICES[MEDIA["device"]]["id"]


def media_track_payloads():
    title, artist, album, genre, year, dur = LIBRARY[MEDIA["track"]]
    m = _msid()
    return {
        "nowPlaying": {"title": title, "artist": artist, "album": album, "genre": genre,
                       "year": str(year), "composer": "", "filename": f"{title}.mp3", "msid": m},
        "trackState": {"totalTracks": len(LIBRARY), "fid": 0, "track": MEDIA["track"] + 1, "msid": m},
        "playTime": {"time": MEDIA["time"], "duration": dur, "msid": m},
        "playState": {"state": "playing" if MEDIA["playing"] else "paused", "msid": m, "handle": 0},
    }


def media_publish(keys=("trackState", "nowPlaying", "playState", "playTime")):
    p = media_track_payloads()
    m = B.mod("Media")
    for k in keys:
        m[k] = p[k]
        B.send("Media", {k: p[k]})


def media_device_payloads():
    d = DEVICES[MEDIA["device"]]
    # deviceState needs "available": MediaPlayer.processDevice drops the current device
    # (and its readyToBrowse) when it is missing, which greys out browse.
    return {"activeDevice": {"device": d}, "deviceState": {"device": d, "state": "connected", "available": True},
            "devicePlayable": {"devicePlayable": True}, "readyToBrowse": {"id": d["id"], "status": True},
            "repeat": {"mode": MEDIA["repeat"]}, "random": {"mode": MEDIA["random"]},
            "syncState": {"state": "complete", "msid": d["id"]},
            "DeviceCapability": {"randomSupported": True, "repeatSupported": True}}


def media_select_device(name):
    if name not in DEVICES:
        return
    if name != MEDIA["device"]:
        MEDIA.update(device=name, track=0, time=0)
    MEDIA["playing"] = True
    m = B.mod("Media")
    for k, v in media_device_payloads().items():
        m[k] = v
        B.send("Media", {k: v})
    media_publish()
    # The real service reports "ready to browse" once indexing finishes, after the HMI has
    # loaded the media screen; sent immediately, the screen misses it and greys out browse.
    import threading
    threading.Timer(1.0, lambda: B.send("Media", {"readyToBrowse": m["readyToBrowse"]})).start()


def media_skip(delta):
    MEDIA["track"] = (MEDIA["track"] + delta) % len(LIBRARY)
    MEDIA["time"] = 0
    media_publish()


def _media_reply(cmd, conn, **extra):
    B.send("Media", {cmd: dict({"description": "success"}, **extra)}, conn)


@on("Media", "getDevices")
def media_get_devices(dest, args, conn):
    devs = [{"available": True, "device": d} for d in DEVICES.values()]
    B.send("Media", {"getDevices": {"devices": devs}}, conn)


for _cmd, _fn in {
    "play": lambda: MEDIA.update(playing=True), "resume": lambda: MEDIA.update(playing=True),
    "playAll": lambda: MEDIA.update(playing=True), "pause": lambda: MEDIA.update(playing=False),
    "stop": lambda: MEDIA.update(playing=False),
}.items():
    def _transport(dest, args, conn, _cmd=_cmd, _fn=_fn):
        _fn()
        _media_reply(_cmd, conn)
        media_publish(("playState",))
    _pending.append(("Media", _cmd, _transport))


@on("Media", "deSelectActiveDevice")
def media_deselect(dest, args, conn):
    MEDIA["playing"] = False
    media_publish(("playState",))


@on("Media", "next")
def media_next(dest, args, conn):
    _media_reply("next", conn)
    media_skip(1)


@on("Media", "previous")
def media_prev(dest, args, conn):
    _media_reply("previous", conn)
    # Like the real unit: restart the song unless we are in its first seconds.
    if MEDIA["time"] > 3:
        MEDIA["time"] = 0
        media_publish(("playTime",))
    else:
        media_skip(-1)


@on("Media", "getAlbumArt")
def media_album_art(dest, args, conn):
    # No cover art on the stick: empty path keeps the default note icon.
    B.send("Media", {"getAlbumArt": {"path": "", "msid": _msid()}}, conn)


@on("Media", "getCurrentTrackList")
def media_track_list(dest, args, conn):
    start = int(args.get("start", 1)) - 1
    count = int(args.get("count", len(LIBRARY)))
    items = [{"id": i + 1, "type": "song", "name": LIBRARY[i][0]}
             for i in range(start, min(len(LIBRARY), start + count))]
    B.send("Media", {"getCurrentTrackList": {"items": items, "code": 0}}, conn)


# Browse tree: root -> categories -> genre -> artist -> album -> songs. Ids 0 and 1 are the
# HMI's "*all*"/"$unknown$" wildcards (MediaPlayerTrackInfo), so real items start at 2.
# "folders" must exist: PlayerBrowseScreen opens on the first category (folders for USB).
CATEGORIES = ["folders", "artists", "albums", "genres", "songs"]
CAT_KIND = {"folders": "song", "songs": "song", "artists": "artist", "albums": "album", "genres": "genre"}
COLS = {"artist": 1, "album": 2, "genre": 3}
BELOW = {"genre": "artist", "artist": "album", "album": "song"}
ALL = "*all*"
BROWSE = {"stack": [("root", None, {})]}  # (kind, name, filter {col: value})


def _uniq(seq):
    return list(dict.fromkeys(seq))


def _match(i, filt):
    return all(LIBRARY[i][COLS[k]] == v for k, v in filt.items())


def _level(kind, filt):
    lib = [i for i in range(len(LIBRARY)) if _match(i, filt)]
    if kind == "song":
        return [{"type": "song", "name": LIBRARY[i][0], "track": i, "filt": filt} for i in lib]
    return [{"type": kind, "name": n, "browsable": True, "filt": dict(filt, **{kind: n})}
            for n in sorted(_uniq(LIBRARY[i][COLS[kind]] for i in lib))]


def browse_children(node):
    kind, name, filt = node
    if kind == "root":
        kids = [{"type": "category", "name": c, "browsable": True, "filt": {}} for c in CATEGORIES]
    elif kind == "category":
        kids = _level(CAT_KIND[name], filt)
    else:
        kids = _level("song" if name == ALL else BELOW[kind], filt)
    for n, c in enumerate(kids):
        c["id"] = n + 2
    if kind == "artist":  # "All Songs" of this artist, shown first like the real unit
        kids.insert(0, {"type": "album", "name": ALL, "browsable": True, "filt": filt, "id": 0})
    return kids


def browse_items():
    out = []
    for c in browse_children(BROWSE["stack"][-1]):
        item = {"id": c["id"], "type": c["type"], "name": c["name"], "browsable": c.get("browsable", False),
                "playable": c["type"] == "song"}
        if c.get("track") == MEDIA["track"]:
            item["nowPlaying"] = True
        out.append(item)
    return out


def browse_selection(conn, ack):
    B.send("Media", {ack: {"description": "success"}}, conn)
    kind, name, _ = BROWSE["stack"][-1]
    B.send("Media", {"selection": {"track": 0, "count": len(browse_children(BROWSE["stack"][-1])),
                                   "name": name or "root", "type": kind, "alphaJumpAvailable": False}}, conn)


def browse_play(tracks, conn):
    if tracks:
        MEDIA.update(track=tracks[0], time=0, playing=True)
        media_publish()


@on("Media", "gotoRoot")
def media_goto_root(dest, args, conn):
    BROWSE["stack"] = [("root", None, {})]
    browse_selection(conn, "gotoRoot")


@on("Media", "gotoPrevious")
def media_goto_prev(dest, args, conn):
    if len(BROWSE["stack"]) > 1:
        BROWSE["stack"].pop()
    browse_selection(conn, "gotoPrevious")


@on("Media", "selectDevice")
def media_select_dev(dest, args, conn):
    BROWSE["stack"] = [("root", None, {})]
    B.send("Media", {"selectDevice": {"description": ""}}, conn)
    browse_selection(conn, "gotoRoot")


@on("Media", "selectItem")
def media_select_item(dest, args, conn):
    node = BROWSE["stack"][-1]
    c = next((c for c in browse_children(node) if c["id"] == int(args.get("id", -1))), None)
    if c is None:
        return B.send("Media", {"selectItem": {"description": "failed"}}, conn)
    if c["type"] == "song":
        B.send("Media", {"selectItem": {"description": "success"}}, conn)
        return browse_play([c["track"]], conn)
    BROWSE["stack"].append(("category", c["name"], {}) if node[0] == "root" else (c["type"], c["name"], c["filt"]))
    browse_selection(conn, "selectItem")


@on("Media", "selectAll")
def media_select_all(dest, args, conn):
    tracks = [i for i in range(len(LIBRARY)) if _match(i, BROWSE["stack"][-1][2])]
    B.send("Media", {"selectAll": {"description": "success"}}, conn)
    browse_play(tracks, conn)


@on("Media", "getItems")
def media_get_items(dest, args, conn):
    items = browse_items()
    start = int(args.get("start", 1)) - 1
    count = int(args.get("count", len(items)))
    B.send("Media", {"getItems": {"request": "getItems", "items": items[start:start + count]}}, conn)


@on("Media", "seekToTime")
def media_seek_time(dest, args, conn):
    MEDIA["time"] = int(args.get("sec", args.get("time", 0)))
    B.send("Media", {"seekToTime": {"description": "success"}}, conn)
    media_publish(("playTime",))


@on("Media", "setProperties")
def media_set_props(dest, args, conn):
    props = args.get("props", args)
    for k in ("repeat", "random"):
        if k in props:
            mode = props[k]["mode"] if isinstance(props[k], dict) else props[k]
            MEDIA[k] = mode
            B.mod("Media")[k] = {"mode": mode}
            B.send("Media", {k: {"mode": mode}})
    B.send("Media", {"setProperties": {}}, conn)


# ---------------------------------------------------------------- Volume
VOLUME = {"level": 14, "cap": 38}


@on("AudioSettings", "setVolume")
def set_volume(dest, args, conn):
    VOLUME["level"] = max(0, min(VOLUME["cap"], int(args.get("volume", VOLUME["level"]))))
    sig = {"volume": VOLUME["level"], "cap": VOLUME["cap"]}
    B.mod("AudioSettings")["volume"] = sig
    B.STATE["_replies"]["AudioSettings"]["getVolume"] = {"volume": VOLUME["level"]}
    B.send("AudioSettings", {"volume": sig})


# ---------------------------------------------------------------- Hardware panel actions
def hard_key(key):
    """Faceplate / ICS button: press then release, as the IOC reports it."""
    B.send("ICS", {"key": {"key": key, "pressed": True}})
    time.sleep(0.12)
    B.send("ICS", {"key": {"key": key, "pressed": False}})


def panel_action(action, value=None):
    if action == "key":
        hard_key(value)
    elif action == "volume":
        B.send("ICS", {"UpdateVolume": {"vol": int(value)}})
    elif action == "tune":
        B.send("ICS", {"knob": {"knob": 2, "value": int(value)}})
    elif action == "gear":
        B.mod("Camera")["prndstatus"] = {"prndstatus": value}
        B.send("Camera", {"prndstatus": {"prndstatus": value}})
    elif action == "temp":
        zone, delta = value.split(":")
        hvac_set("HVAC", {"zone": zone, "controls": {"tempUp" if delta == "+" else "tempDown": "press"}}, None)
    elif action == "inject":
        import json as _j
        frame = _j.loads(value)
        for mod_name, payload in frame.items():
            B.send(mod_name, payload)
    else:
        raise ValueError(action)


# ---------------------------------------------------------------- periodic
def ticker():
    """Signals a real car pushes on its own: minute clock ticks."""
    last_min = None
    while True:
        src = B.mod("Audio").get("audioSource", {}).get("source")
        if src in DEVICES and src == MEDIA["device"] and MEDIA["playing"]:
            MEDIA["time"] += 1
            if MEDIA["time"] >= LIBRARY[MEDIA["track"]][5]:
                media_skip(0 if MEDIA["repeat"] == "song" else 1)
            else:
                media_publish(("playTime",))
        t = time.localtime()
        if t.tm_min != last_min:
            last_min = t.tm_min
            B.send("Clock", {"time": now_payload()})
        time.sleep(1)
