"""Phone + Bluetooth: paired "Pixel 8" (HFP + A2DP), phonebook, favorites, recent calls,
SMS inbox and a call state machine.

Shapes come from MainSupplement moduleLink classes: Bluetooth.as (Dest BluetoothGAP),
BluetoothHFP.as, PhoneBook.as (Dest PhoneBook, databases "pb" contacts / "ab" favorites),
PhoneCallList.as, SMSMessaging.as (Dest PimService).

Simulated phone events go through the panel's raw inject with a pseudo-module "PhoneSim":
    python dev/uc.py NAME act inject '{"PhoneSim":{"incomingCall":{"name":"Mom","number":"3135550142"}}}'
    python dev/uc.py NAME act inject '{"PhoneSim":{"incomingSMS":{"name":"Mom","number":"3135550142","body":"Hi"}}}'
    python dev/uc.py NAME act inject '{"PhoneSim":{"remoteHangup":{}}}'
"""
import json, threading, time
import handlers as H
from handlers import on

# ---------------------------------------------------------------- data
PHONES = [  # paired devices; HFP/A2DP priority 1 = favourite (listed first)
    {"address": "A4:C1:38:5E:22:7B", "name": "Pixel 8", "hfp": True, "a2dp": True, "prio": 1},
    {"address": "F0:99:B6:12:4A:9C", "name": "Sarah's iPhone", "hfp": False, "a2dp": False, "prio": 2},
]
CARRIER = {"operatorCode": "311480", "operatorLongName": "Verizon Wireless", "operatorShortName": "Verizon",
           "operatorMode": "automatic", "operatorAccTech": "LTE"}
SIGNAL, BATTERY = 18, 4  # HMI scales: signal 0..31 (>21 = 5 bars), battery 0..5
NAMES = {"head": "Uconnect"}  # the head unit's own Bluetooth name (what the phone sees)


def set_names(phone=None, head=None, announce=True):
    """Panel "phone": rename the connected phone and/or the head unit's Bluetooth name; kept in config.json."""
    if phone:
        PHONES[0]["name"] = phone[:40]
    if head:
        NAMES["head"] = head[:40]
    _media_device_name()
    H.update_config(phoneName=PHONES[0]["name"], btName=NAMES["head"])
    if announce:  # the HMI re-reads the paired list on this signal (Bluetooth.as)
        H.B.send("BluetoothGAP", {"pairedDeviceList": {}})
        H.B.send("BluetoothGAP", {"localDeviceName": {"localDeviceName": NAMES["head"]}})


def phone_action(value):
    v = json.loads(value) if isinstance(value, str) else value
    set_names(str(v.get("name", "")).strip(), str(v.get("btName", "")).strip())


def api_phone():
    return {"name": PHONES[0]["name"], "btName": NAMES["head"]}

# (given, family, mobile, home, work)
_PEOPLE = [
    ("Mom", "", "3135550142", "3135550188", ""),
    ("Dad", "", "3135550143", "3135550188", ""),
    ("Sarah", "Johnson", "2485550117", "", "2485550190"),
    ("Mike", "Anderson", "7345550163", "", ""),
    ("Emily", "Davis", "3135550174", "", "3135550600"),
    ("Chris", "Martinez", "5865550129", "", ""),
    ("Jessica", "Brown", "2485550151", "2485550152", ""),
    ("David", "Wilson", "7345550134", "", "7345550900"),
    ("Ashley", "Taylor", "3135550196", "", ""),
    ("Brian", "Thomas", "9475550108", "", ""),
    ("Amanda", "Moore", "2485550185", "", ""),
    ("Kevin", "Jackson", "3135550121", "", "3135550700"),
    ("Lauren", "White", "5865550147", "", ""),
    ("Jason", "Harris", "7345550158", "7345550159", ""),
    ("Megan", "Clark", "2485550133", "", ""),
    ("Ryan", "Lewis", "3135550166", "", ""),
    ("Nicole", "Walker", "9475550172", "", ""),
    ("Dr. Patel", "Office", "", "", "2485550100"),
    ("Joe's", "Pizza", "", "", "3135550111"),
    ("Tom", "Young", "5865550199", "", ""),
    ("Rachel", "King", "7345550145", "", ""),
    ("Grandma", "", "", "3135550177", ""),
]
CONTACTS = sorted(({"givenName": g, "familyName": f, "formattedName": (g + " " + f).strip(),
                    "mobileNumber": m, "homeNumber": h, "workNumber": w, "otherNumber": ""}
                   for g, f, m, h, w in _PEOPLE), key=lambda c: c["formattedName"].lower())
for _i, _c in enumerate(CONTACTS):
    _c["contactsId"] = _i + 1

FAV_FIELDS = ("formattedName", "givenName", "familyName", "workNumber", "homeNumber", "mobileNumber", "otherNumber")


def _fav(fav_index, name, **nums):
    c = dict({k: "" for k in FAV_FIELDS}, formattedName=name, givenName=name, favIndex=fav_index)
    c.update(nums)
    return c


# "ab" database: favourite slots 1..5 plus the fixed Emergency (6) / Towing Assistance (7) rows.
FAVORITES = [_fav(1, "Mom", mobileNumber="3135550142"), _fav(2, "Sarah Johnson", mobileNumber="2485550117"),
             _fav(3, "Mike Anderson", mobileNumber="7345550163"),
             _fav(6, "Emergency", otherNumber="911"), _fav(7, "Towing Assistance", otherNumber="8005212779")]
_next_fav_id = [100]
for _f in FAVORITES:
    _f["contactsId"] = _next_fav_id[0]
    _next_fav_id[0] += 1

# Recent calls: (StorageType DC/RC/MC, number, minutes ago); names come from the phonebook.
HISTORY = [("MC", "3135550142", 14), ("RC", "2485550117", 52), ("DC", "7345550163", 95),
           ("DC", "3135550111", 180), ("RC", "3135550143", 300), ("MC", "8885550123", 420),
           ("DC", "2485550151", 1500), ("RC", "3135550174", 1620), ("DC", "3135550142", 2900),
           ("MC", "5865550129", 3100), ("RC", "7345550134", 4400), ("DC", "2485550100", 5800)]
HISTORY = [{"type": t, "number": n, "time": time.time() - m * 60} for t, n, m in HISTORY]

SMS = [  # newest first
    ("Mom", "3135550142", "Dinner at 6 tonight? Bring the kids!", 9, False),
    ("Sarah Johnson", "2485550117", "Running 10 min late, save me a seat", 41, False),
    ("Mike Anderson", "7345550163", "Got the tickets for Saturday's game", 130, True),
    ("", "8885550123", "Your package was delivered. Reply STOP to opt out.", 600, True),
    ("Chris Martinez", "5865550129", "Can you send me the address again?", 1440, True),
]
SMS = [{"uid_messageId": str(i + 1), "smsName": n, "smsFrom": num, "smsBody": body,
        "localTimeStamp": "", "smsReadStatus": read, "numberType": "mobileNumber", "_t": time.time() - m * 60}
       for i, (n, num, body, m, read) in enumerate(SMS)]

CALLS = {}  # callId -> {"callId","callState","number","name","numberType","audio","start","incoming"}
STATE = {"next_call": 1, "hf_mode": True, "last_dialed": "3135550111", "lock": threading.Lock()}


def _ts(t):
    return time.strftime("%Y-%m-%d %H:%M:%S", time.localtime(t))


def _digits(n):
    return "".join(ch for ch in str(n) if ch.isdigit())[-10:]


def lookup(number):
    """(contact, numberType) for a phone number, matching on the last 10 digits like the HMI."""
    d = _digits(number)
    for c in CONTACTS:
        for k in ("mobileNumber", "homeNumber", "workNumber", "otherNumber"):
            if d and _digits(c[k]) == d:
                return c, k
    return None, ""


# ---------------------------------------------------------------- BluetoothGAP
def _device(p):
    svcs = [{"service": "HFPGW", "connected": p["hfp"], "priority": p["prio"]},
            {"service": "A2DP_SOURCE", "connected": p["a2dp"], "priority": p["prio"]}]
    # a real phone is listed as a phone too (Paired Phones), though the PC only takes its audio

    return {"address": p["address"], "name": p["name"], "serviceSearchList": svcs}


def _gap(cmd, conn, **extra):
    H.B.send("BluetoothGAP", {cmd: dict({"description": "success", "code": 0}, **extra)}, conn)


@on("BluetoothGAP", "setBluetoothStatus")
def gap_status(dest, args, conn):
    _gap("setBluetoothStatus", conn)


def gap_paired(dest, args, conn):
    _gap("getPairedDeviceList", conn, pairedDeviceList=[_device(p) for p in PHONES])


@on("BluetoothGAP", "getProperties")
def gap_props(dest, args, conn):
    vals = {"passkey": {"pin": "1234"}, "localDeviceName": {"localDeviceName": NAMES["head"]},
            "bluetoothAddress": {"address": "00:1E:AE:4C:91:07"}}
    H.B.send("BluetoothGAP", {"getProperties": {p: vals[p] for p in args.get("properties", []) if p in vals}}, conn)


def _phone(address):
    return next((p for p in PHONES if p["address"] == address), None)


SERVICE_KEY = {"HFPGW": "hfp", "A2DP_SOURCE": "a2dp"}


def _set_service(p, service, connected):
    if p[SERVICE_KEY[service]] == connected:
        return
    p[SERVICE_KEY[service]] = connected
    if connected:
        H.B.send("BluetoothGAP", {"serviceConnected": {"address": p["address"], "service": service}})
    else:
        H.B.send("BluetoothGAP", {"serviceDisconnected": {"address": p["address"], "service": service,
                                                           "reason": "userRequest"}})


def _hfp_connected():
    return next((p for p in PHONES if p["hfp"]), None)


def _media_device_name():
    # BT audio source shows whichever phone streams A2DP.
    p = next((p for p in PHONES if p["a2dp"]), None)
    if p:
        H.DEVICES["btsa"]["name"] = p["name"]


# ---------------------------------------------------------------- real phones (modules/btreal)
def real_phones_changed(announce=True):
    """Match PHONES to the phones paired with the PC's Bluetooth (they stream audio only: no HFP)."""
    from modules import btreal
    real = btreal.STATE["phones"]
    for p in [p for p in PHONES if p.get("real") and p["address"] not in real]:
        PHONES.remove(p)
    for addr, r in real.items():
        if not _phone(addr):
            PHONES.append({"address": addr, "name": r["name"], "hfp": False, "a2dp": False, "prio": 0, "real": True})
    for i, x in enumerate(PHONES):
        x["prio"] = i + 1
    if announce:
        H.B.send("BluetoothGAP", {"pairedDeviceList": {}})


def _real_connect(p):
    from modules import btreal
    if btreal.connect(p["address"]):
        for other in PHONES:
            if other is not p:
                _set_service(other, "A2DP_SOURCE", False)
                _set_service(other, "HFPGW", False)
        _set_service(p, "A2DP_SOURCE", True)
        # Windows cannot be a hands-free kit, so calls/contacts/texts stay simulated, but under the real phone,
        # like the car shows the one connected phone everywhere (Phone screen, status bar).
        _set_service(p, "HFPGW", True)
        threading.Timer(0.5, _pim_sync).start()
        _media_device_name()
        # like the car when a phone's audio connects: switch to Bluetooth audio, Media shows the phone
        H.audio_set_source("Audio", {"source": "btsa"}, None)
    else:
        H.B.send("BluetoothGAP", {"serviceConnectError": {"address": p["address"], "service": "A2DP_SOURCE",
                                                          "reason": "connectFailed"}})


def connect_real(address):
    p = _phone(address)
    if p:
        threading.Thread(target=_real_connect, args=(p,), daemon=True).start()


def real_audio_lost(address):
    p = _phone(address)
    if p:
        _set_service(p, "A2DP_SOURCE", False)


def _real_startup():
    """Like the car at ignition: list the PC's paired phones, reconnect the first one's audio."""
    from modules import btreal
    time.sleep(2)  # the WinRT thread is starting
    if not btreal.refresh():
        return
    real_phones_changed()
    first = next((p for p in PHONES if p.get("real")), None)
    if first:
        _real_connect(first)


@on("BluetoothGAP", "startServiceConnect")
def gap_connect(dest, args, conn):
    p, service = _phone(args.get("address")), args.get("service")
    if not p or service not in SERVICE_KEY:
        return _gap("startServiceConnect", conn, description="failure")
    _gap("startServiceConnect", conn)
    if p.get("real") and service == "A2DP_SOURCE":  # opening the phone's stream takes a few seconds
        return threading.Thread(target=_real_connect, args=(p,), daemon=True).start()
    for other in PHONES:  # one phone per profile, like the real head unit
        if other is not p:
            _set_service(other, service, False)
    _set_service(p, service, True)
    _media_device_name()
    if service == "HFPGW":
        threading.Timer(0.5, _pim_sync).start()  # new phone -> phonebook / recents re-sync


@on("BluetoothGAP", "startServiceDisconnect")
def gap_disconnect(dest, args, conn):
    p, service = _phone(args.get("address")), args.get("service")
    _gap("startServiceDisconnect", conn)
    if p and service in SERVICE_KEY:
        if p.get("real") and service == "A2DP_SOURCE":
            from modules import btreal
            btreal.disconnect()
        _set_service(p, service, False)


@on("BluetoothGAP", "setFavourite")
def gap_favourite(dest, args, conn):
    p = _phone(args.get("address"))
    if p:
        PHONES.sort(key=lambda x: x is not p)
        for i, x in enumerate(PHONES):
            x["prio"] = i + 1
    _gap("setFavourite", conn)


@on("BluetoothGAP", "startDeviceUnpairing")
def gap_unpair(dest, args, conn):
    p = _phone(args.get("address"))
    if p:
        for s in SERVICE_KEY:
            _set_service(p, s, False)
        if p.get("real"):  # forget it in Windows too
            from modules import btreal
            threading.Thread(target=btreal.unpair, args=(p["address"],), daemon=True).start()
        PHONES.remove(p)
        for i, x in enumerate(PHONES):
            x["prio"] = i + 1
        H.B.send("BluetoothGAP", {"deviceUnpaired": {"address": p["address"]}})


@on("BluetoothGAP", "startDeviceSearch")
def gap_search(dest, args, conn):
    _gap("startDeviceSearch", conn)


# ---------------------------------------------------------------- PimService sync / SMS
def _pim_sync(conn=None):
    """Tell PhoneBook / PhoneCallList / SMSMessaging that the phone's data finished syncing."""
    for obj in ("Contacts", "CallStack", "SMS"):
        H.B.send("PimService", {"pimObjectSyncState": {"objectType": obj, "syncStatus": "syncComplete"}}, conn)


@on("PimService", "getProperties")
def pim_props(dest, args, conn):
    vals = {"pimSupportedFeatures": [{"objectType": "SMS", "syncSupport": "yes", "sendSupport": "yes"}],
            "pimObjectSyncState": [{"objectType": o, "syncState": "syncComplete"}
                                   for o in ("contacts", "callStack", "sms")]}
    H.B.send("PimService", {"getProperties": {p: vals[p] for p in args.get("properties", []) if p in vals}}, conn)


def _sms_out(m):
    return dict({k: v for k, v in m.items() if k != "_t"}, localTimeStamp=_ts(m["_t"]))


@on("PimService", "getSMSCount")
def sms_count(dest, args, conn):
    H.B.send("PimService", {"getSMSCount": {"smsCount": len(SMS), "code": 0, "description": "success"}}, conn)


@on("PimService", "getUnreadSMSCount")
def sms_unread_count(dest, args, conn):
    n = sum(1 for m in SMS if not m["smsReadStatus"])
    H.B.send("PimService", {"getUnreadSMSCount": {"smsCount": n, "code": 0, "description": "success"}}, conn)


def _sms_page(cmd, msgs, args, conn):
    start, num = int(args.get("startSMSFrom", 0)), int(args.get("numSMS", 0) or len(msgs))
    H.B.send("PimService", {cmd: {"smsList": [_sms_out(m) for m in msgs[start:start + num]], "code": 0}}, conn)


@on("PimService", "getSMSList")
def sms_list(dest, args, conn):
    _sms_page("getSMSList", SMS, args, conn)


@on("PimService", "getUnreadSMSList")
def sms_unread_list(dest, args, conn):
    _sms_page("getUnreadSMSList", [m for m in SMS if not m["smsReadStatus"]], args, conn)


@on("PimService", "getNewSMS")
def sms_get(dest, args, conn):
    m = next((m for m in SMS if m["uid_messageId"] == str(args.get("UID"))), None)
    H.B.send("PimService", {"getNewSMS": {"smsList": [_sms_out(m)] if m else [], "code": 0}}, conn)


@on("PimService", "setSMSReadStatus")
def sms_read(dest, args, conn):
    for m in SMS:
        if m["uid_messageId"] == str(args.get("messageUID")):
            m["smsReadStatus"] = True
    H.B.send("PimService", {"setSMSReadStatus": {"description": "success", "code": 0}}, conn)


@on("PimService", "sendSms")
def sms_send(dest, args, conn):
    H.B.send("PimService", {"sendSms": {"description": "success", "code": 0}}, conn)
    threading.Timer(1.0, lambda: H.B.send("PimService", {"sentMessageStatus": {
        "notificationType": "SENDING_SUCCESS"}})).start()


def incoming_sms(name, number, body):
    if not name:
        c, _ = lookup(number)
        name = c["formattedName"] if c else ""
    m = {"uid_messageId": str(max(int(x["uid_messageId"]) for x in SMS) + 1 if SMS else 1), "smsName": name,
         "smsFrom": number, "smsBody": body, "smsReadStatus": False, "numberType": "mobileNumber",
         "_t": time.time()}
    SMS.insert(0, m)
    H.B.send("PimService", {"newSMS": {"message": _sms_out(m)}})


# ---------------------------------------------------------------- PhoneBook (contacts + favorites)
def _matches(c, text):
    text = (text or "").lower()
    return not text or any(w.lower().startswith(text) for w in c["formattedName"].split()) \
        or c["formattedName"].lower().startswith(text)


def _pb(cmd, conn, **payload):
    H.B.send("PhoneBook", {cmd: dict({"status": "success", "code": 0}, **payload)}, conn)


@on("PhoneBook", "getItemsCount")
def pb_count(dest, args, conn):
    db = args.get("database", "pb")
    n = len(FAVORITES) if db == "ab" else sum(1 for c in CONTACTS if _matches(c, args.get("filterCriteria")))
    _pb("getItemsCount", conn, count=n, database=db)


@on("PhoneBook", "getItems")
def pb_items(dest, args, conn):
    db = args.get("database", "pb")
    if db == "sms":  # custom SMS template: none stored ("success" would clobber the contact cache)
        return H.B.send("PhoneBook", {"getItems": {"status": "failure", "database": db}}, conn)
    rows = sorted(FAVORITES, key=lambda f: f["favIndex"]) if db == "ab" else \
        [c for c in CONTACTS if _matches(c, args.get("filterCriteria"))]
    start = int(args.get("startId", 0))
    count = int(args.get("count", len(rows)) or len(rows))
    _pb("getItems", conn, database=db, result=rows[start:start + count])


@on("PhoneBook", "getAlphaJumpTable")
def pb_alpha(dest, args, conn):
    table = {}
    for i, c in enumerate(CONTACTS):
        table.setdefault(c["formattedName"][0].upper(), i)
    _pb("getAlphaJumpTable", conn, result={"alphaTable": [{k: v} for k, v in table.items()]})


@on("PhoneBook", "getNextValidCharacters")
def pb_next_chars(dest, args, conn):
    text = args.get("inputName", "")
    hits = [i for i, c in enumerate(CONTACTS) if _matches(c, text)]
    nxt = set()
    for c in CONTACTS:
        for w in [c["formattedName"]] + c["formattedName"].split():
            if w.lower().startswith(text.lower()) and len(w) > len(text):
                nxt.add(w[len(text)].lower())
    _pb("getNextValidCharacters", conn, result={"characterMask": "".join(sorted(nxt)),
                                                "index": hits[0] if hits else 0, "count": len(hits)})


@on("PhoneBook", "getNameByPhoneNum")
def pb_by_number(dest, args, conn):
    c, kind = lookup(args.get("phoneNumber", ""))
    if not c:
        return _pb("getNameByPhoneNum", conn, status="failure")
    _pb("getNameByPhoneNum", conn, result=[dict(c, numberType=kind)])


@on("PhoneBook", "getPhoneNumByName")
def pb_by_name(dest, args, conn):
    g, f = args.get("givenName", "").lower(), args.get("lastName", "").lower()
    items = [c for c in CONTACTS if (not g or c["givenName"].lower() == g) and (not f or c["familyName"].lower() == f)]
    _pb("getPhoneNumByName", conn, result={"items": items})


@on("PhoneBook", "insertItems")
def pb_insert(dest, args, conn):
    for item in args.get("insertList", []):
        FAVORITES[:] = [f for f in FAVORITES if f["favIndex"] != item.get("favIndex")]
        new = _fav(item.get("favIndex", 0), item.get("formattedName", ""))
        new.update({k: item.get(k) or "" for k in FAV_FIELDS})
        new["contactsId"], _next_fav_id[0] = _next_fav_id[0], _next_fav_id[0] + 1
        FAVORITES.append(new)
    _pb("insertItems", conn, database="ab")


@on("PhoneBook", "updateItems")
def pb_update(dest, args, conn):
    for item in args.get("fieldsList", []):
        cur = next((f for f in FAVORITES if f["favIndex"] == item.get("favIndex")), None)
        if cur is None:
            cur = _fav(item.get("favIndex", 0), "")
            cur["contactsId"], _next_fav_id[0] = _next_fav_id[0], _next_fav_id[0] + 1
            FAVORITES.append(cur)
        cur.update({k: item[k] for k in FAV_FIELDS if item.get(k) is not None})
    _pb("updateItems", conn, database="ab")


@on("PhoneBook", "deleteItems")
def pb_delete(dest, args, conn):
    ids = {int(x) for x in str(args.get("deleteList", "")).split(",") if x.strip().isdigit()}
    FAVORITES[:] = [f for f in FAVORITES if f["contactsId"] not in ids]
    _pb("deleteItems", conn, database="ab")


@on("PhoneBook", "refreshPhonebook")
def pb_refresh(dest, args, conn):
    _pb("refreshPhonebook", conn)
    H.B.send("PimService", {"pimObjectSyncState": {"objectType": "Contacts", "syncStatus": "syncComplete"}})


# ---------------------------------------------------------------- PhoneCallList
def _history_rows(kind):
    rows = sorted((h for h in HISTORY if kind in (None, h["type"])), key=lambda h: -h["time"])
    out = []
    for h in rows:
        c, ntype = lookup(h["number"])
        out.append({"givenName": c["givenName"] if c else h["number"], "lastName": c["familyName"] if c else "",
                    "telephoneNumber": h["number"], "StorageType": h["type"], "timeStamp": _ts(h["time"]),
                    "numberType": ntype})
    return out


for _cmd, _kind in {"getAllCallsCount": None, "getDialedCallsCount": "DC", "getReceivedCallsCount": "RC",
                    "getMissedCallsCount": "MC"}.items():
    def _count(dest, args, conn, _cmd=_cmd, _kind=_kind):
        H.B.send("PhoneCallList", {_cmd: {"callstackCount": len(_history_rows(_kind))}}, conn)
    H._pending.append(("PhoneCallList", _cmd, _count))

for _cmd, _kind in {"getAllCallLists": None, "getDialedCallList": "DC", "getReceivedCallList": "RC",
                    "getMissedCallList": "MC"}.items():
    def _list(dest, args, conn, _cmd=_cmd, _kind=_kind):
        start, num = int(args.get("startCallstacksFrom", 0)), int(args.get("numCallstacks", 20))
        rows = _history_rows(_kind)[start:start + num]
        H.B.send("PhoneCallList", {_cmd: {"description": "success", "callstacksList": rows}}, conn)
    H._pending.append(("PhoneCallList", _cmd, _list))


def _log_call(kind, number):
    if number:
        HISTORY.append({"type": kind, "number": number, "time": time.time()})
        H.B.send("PimService", {"newCallList": {"storageType": kind, "phoneNumber": number}})


# ---------------------------------------------------------------- BluetoothHFP (calls)
def _hfp(cmd, conn, **extra):
    H.B.send("BluetoothHFP", {cmd: dict({"description": "success", "code": 0}, **extra)}, conn)


def _call_info(c):
    return {"callId": c["callId"], "callState": c["callState"], "number": c["number"], "name": c["name"],
            "numberType": c["numberType"], "audio": c["audio"], "duration": int(time.time() - c["start"])}


def publish_calls(extra=()):
    info = [_call_info(c) for c in CALLS.values()] + list(extra)
    H.B.mod("BluetoothHFP")["callState"] = {"callStateInfo": [i for i in info if i["callState"] != "idle"]}
    H.B.send("BluetoothHFP", {"callState": {"callStateInfo": info}})


def _set_state(call_id, state):
    with STATE["lock"]:
        c = CALLS.get(call_id)
        if not c:
            return
        if state == "idle":
            del CALLS[call_id]
            if c["incoming"]:
                _log_call("RC" if c["answered"] else "MC", c["number"])
            else:
                _log_call("DC", c["number"])
            c["callState"] = "idle"
            publish_calls([_call_info(c)])
            return
        if state == "active" and c["callState"] != "onhold":
            c["start"] = time.time()  # call timer counts from pick-up, not from dialing
        c["callState"] = state
        if state == "active":
            c["answered"] = True
        publish_calls()


def _new_call(number, name, ntype, state, incoming):
    if not name:
        c, kind = lookup(number)
        name, ntype = (c["formattedName"], ntype or kind) if c else ("", ntype)
    with STATE["lock"]:
        cid = STATE["next_call"]
        STATE["next_call"] += 1
        CALLS[cid] = {"callId": cid, "callState": state, "number": number, "name": name or "",
                      "numberType": ntype or "", "audio": STATE["hf_mode"], "start": time.time(),
                      "incoming": incoming, "answered": False}
    publish_calls()
    return cid


def _later(sec, fn, *a):
    threading.Timer(sec, fn, a).start()


def dial(number, name="", ntype=""):
    if not _hfp_connected():
        return None
    for c in list(CALLS.values()):  # dialing a second call puts the first on hold
        if c["callState"] == "active":
            c["callState"] = "onhold"
    STATE["last_dialed"] = number
    cid = _new_call(number, name, ntype, "dialing", False)
    _later(1.0, lambda: CALLS.get(cid, {}).get("callState") == "dialing" and _set_state(cid, "alerting"))
    _later(3.0, lambda: CALLS.get(cid, {}).get("callState") == "alerting" and _set_state(cid, "active"))
    return cid


@on("BluetoothHFP", "dial")
def hfp_dial(dest, args, conn):
    cid = dial(args.get("number", ""), args.get("name", ""), args.get("numberType", ""))
    if cid is None:
        return _hfp("dial", conn, description="failure", reason="phone not connected")
    _hfp("dial", conn, callId=cid)


@on("BluetoothHFP", "reDial")
def hfp_redial(dest, args, conn):
    cid = dial(STATE["last_dialed"])
    _hfp("reDial", conn, callId=cid or 0)


def incoming_call(name="", number="3135550142"):
    """Ring the head unit from the paired phone (call waiting if a call is already up)."""
    if not _hfp_connected():
        return None
    state = "waiting" if any(c["callState"] in ("active", "onhold") for c in CALLS.values()) else "ringing"
    return _new_call(number, name, "", state, True)


def _first(*states):
    return next((c["callId"] for c in CALLS.values() if c["callState"] in states), None)


@on("BluetoothHFP", "acceptIncomingCall")
def hfp_accept(dest, args, conn):
    cid = _first("ringing", "waiting")
    _hfp("acceptIncomingCall", conn)
    if cid is None:
        return
    for c in CALLS.values():
        if c["callState"] == "active":
            c["callState"] = "onhold"
    if args.get("answerAndTransfer") in (True, "true"):
        CALLS[cid]["audio"] = False
    _set_state(cid, "active")


@on("BluetoothHFP", "rejectIncomingCall")
def hfp_reject(dest, args, conn):
    cid = _first("ringing", "waiting")
    _hfp("rejectIncomingCall", conn)
    if cid is not None:
        _set_state(cid, "idle")


@on("BluetoothHFP", "endCall")
def hfp_end(dest, args, conn):
    _hfp("endCall", conn)
    _set_state(int(args.get("callId", 0)), "idle")


@on("BluetoothHFP", "endActiveCall")
def hfp_end_active(dest, args, conn):
    cid = _first("active", "dialing", "alerting") or _first("onhold")
    _hfp("endActiveCall", conn)
    if cid is not None:
        _set_state(cid, "idle")
        held = _first("onhold")
        if held is not None and not _first("active"):
            _set_state(held, "active")


@on("BluetoothHFP", "endAllCalls")
def hfp_end_all(dest, args, conn):
    _hfp("endAllCalls", conn)
    for cid in list(CALLS):
        _set_state(cid, "idle")


@on("BluetoothHFP", "holdActiveCall")
def hfp_hold(dest, args, conn):
    _hfp("holdActiveCall", conn)
    for c in CALLS.values():
        if c["callState"] == "active":
            c["callState"] = "onhold"
    publish_calls()


@on("BluetoothHFP", "resumeHeldCall")
def hfp_resume(dest, args, conn):
    _hfp("resumeHeldCall", conn)
    for c in CALLS.values():
        if c["callState"] == "onhold":
            c["callState"] = "active"
    publish_calls()


@on("BluetoothHFP", "swapCalls")
def hfp_swap(dest, args, conn):
    _hfp("swapCalls", conn)
    for c in CALLS.values():
        c["callState"] = {"active": "onhold", "onhold": "active", "waiting": "active"}.get(c["callState"], c["callState"])
        c["answered"] = c["answered"] or c["callState"] == "active"
    publish_calls()


@on("BluetoothHFP", "conferenceCall")
def hfp_conference(dest, args, conn):
    _hfp("conferenceCall", conn)
    for c in CALLS.values():
        if c["callState"] == "onhold":
            c["callState"] = "active"
    publish_calls()


@on("BluetoothHFP", "setHfMode")
def hfp_hf_mode(dest, args, conn):
    # hfMode false = "transfer to handset": call audio leaves the car.
    on_car = args.get("hfMode") in (True, "true")
    STATE["hf_mode"] = on_car
    _hfp("setHfMode", conn)
    for c in CALLS.values():
        c["audio"] = on_car
    H.B.mod("BluetoothHFP")["handsFreeMode"] = {"hfMode": on_car}
    H.B.send("BluetoothHFP", {"handsFreeMode": {"hfMode": on_car}})
    publish_calls()


@on("BluetoothHFP", "setMuteState")
def hfp_mute(dest, args, conn):
    STATE["muted"] = args.get("muteState") in ("mute", "on", "true", True)
    _hfp("setMuteState", conn)


@on("BluetoothHFP", "getMuteState")
def hfp_get_mute(dest, args, conn):
    _hfp("getMuteState", conn, muteState=STATE.get("muted", False))


@on("AudioSettings", "setSHFMicMute")
def shf_mic_mute(dest, args, conn):
    # Phone screen "Mute" button: the hands-free microphone mute (AudioSettings.as MuteValue).
    mute = args.get("mute") in (True, "true")
    H.B.mod("AudioSettings")["MuteValue"] = {"mutevalue": mute}
    H.B.send("AudioSettings", {"MuteValue": {"mutevalue": mute}})


@on("BluetoothHFP", "sendDtmfTone")
def hfp_dtmf(dest, args, conn):
    _hfp("sendDtmfTone", conn)


@on("BluetoothHFP", "setDNDStatus")
def hfp_dnd(dest, args, conn):
    _hfp("setDNDStatus", conn)


@on("BluetoothHFP", "getProperties")
def hfp_props(dest, args, conn):
    vals = {"signalQuality": {"signalQuality": SIGNAL}, "batteryCharge": {"batteryCharge": BATTERY},
            "networkRegistrationState": {"state": "PHONE_REGSTATE_HOME"}, "networkOperatorChanged": CARRIER,
            "handsFreeMode": {"hfMode": STATE["hf_mode"]}, "audioStatus": {"audioStatus": bool(CALLS)},
            "subscriberNumber": {"number": "3135550100"}, "siriStatus": {"enabled": False, "available": False}}
    H.B.send("BluetoothHFP", {"getProperties": {p: vals[p] for p in args.get("properties", []) if p in vals}}, conn)


# ---------------------------------------------------------------- simulator hooks (panel inject)
def remote_hangup():
    """The far end hangs up (or stops ringing)."""
    cid = _first("active", "dialing", "alerting", "ringing", "waiting")
    if cid is not None:
        _set_state(cid, "idle")


SIM = {"incomingCall": lambda a: incoming_call(a.get("name", ""), a.get("number", "3135550142")),
       "incomingSMS": lambda a: incoming_sms(a.get("name", ""), a.get("number", "3135550142"), a.get("body", "")),
       "remoteHangup": lambda a: remote_hangup()}


def _wrap_panel(orig):
    def panel_action(action, value=None):
        if action == "inject":
            frame = json.loads(value)
            for cmd, a in (frame.pop("PhoneSim", None) or {}).items():
                SIM[cmd](a or {})
            if not frame:
                return
            value = json.dumps(frame)
        return orig(action, value)
    return panel_action


def _ticker():
    # Running call timer: the phone re-reports callState with a growing duration every second.
    while True:
        time.sleep(1)
        with STATE["lock"]:
            if any(c["callState"] in ("active", "onhold") for c in CALLS.values()):
                publish_calls()


def init(B):
    hfp = B.mod("BluetoothHFP")
    hfp.update({"signalQuality": {"rssi": SIGNAL}, "batteryCharge": {"level": BATTERY},
                "networkRegistrationState": {"state": "PHONE_REGSTATE_HOME"}, "networkOperatorChanged": CARRIER,
                "handsFreeMode": {"hfMode": True}, "callState": {"callStateInfo": []},
                "supportedFeaturesList": {"features": "PHONE_FEATURE_SWAP,PHONE_FEATURE_CONFERENCE,"
                                                      "PHONE_FEATURE_REJECT,PHONE_FEATURE_VR"}})
    B.mod("BluetoothGAP")["bluetoothStatus"] = {"status": True}
    # PhoneBook/PhoneCallList/SMSMessaging each subscribe to PimService.pimObjectSyncState; the generic
    # Subscribe replays one value, so Contacts goes there and CallStack/SMS follow in _pim_sync.
    B.mod("PimService")["pimObjectSyncState"] = {"objectType": "Contacts", "syncStatus": "syncComplete"}
    replies = B.STATE.setdefault("_replies", {})
    replies.setdefault("BluetoothGAP", {}).update({c: {"description": "success", "code": 0} for c in (
        "setAccessMode", "stopDeviceSearch", "setPin", "startAutoConnect", "pauseAutoConnect",
        "startDevicePairing", "standardPairingReply", "securePairingReply", "serviceConnectReply",
        "sendDtmfTone", "switchBluetoothOff", "setBTChipMode", "getBTChipBTID")})
    replies.setdefault("BluetoothHFP", {}).update({c: {"description": "success", "code": 0} for c in (
        "setVRMode", "startAutoConnect", "setProperties")})
    c = json.load(open(H.CONFIG_FILE, encoding="utf-8"))
    PHONES[0]["name"] = c.get("phoneName", PHONES[0]["name"])
    NAMES["head"] = c.get("btName", NAMES["head"])
    _media_device_name()
    H.PANEL_ACTIONS["phone"] = phone_action
    from modules import btreal
    if btreal.AVAILABLE:
        threading.Thread(target=_real_startup, daemon=True).start()
    B.API["/api/phone"] = api_phone
    H.panel_action = _wrap_panel(H.panel_action)
    threading.Thread(target=_ticker, daemon=True).start()


# CallStack/SMS sync is pushed once each HMI connection has asked for its paired devices
# (by then PhoneCallList/SMSMessaging are listening).
_synced = set()


def _after_paired(dest, args, conn):
    gap_paired(dest, args, conn)
    if conn not in _synced:
        _synced.add(conn)
        threading.Timer(2.0, _pim_sync, (conn,)).start()


H._pending.append(("BluetoothGAP", "getPairedDeviceList", _after_paired))
