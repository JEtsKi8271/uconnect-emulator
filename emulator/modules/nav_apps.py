"""Navigation, Apps, camera and assorted leftover services (NAFTA unit, no DAB).

The map is drawn natively by NaviServer on the real car; here only the HMI side runs,
so Navigation/NDR answer just enough for the nav menus (ready, activated, GPS fix).
"""
import json, threading
import handlers as H
from handlers import on

HOME = (42.3314, -83.0458)  # Detroit, MI

# Navigation.JSON_GetProperties outprops (Navigation.as distribute_JSON_Prop reads one per frame).
NAV_PROPS = {
    "ETC_IsActivated": True,
    "ETC_IsOperable": True,
}


def ndr_props():
    lat, lon = HOME
    return {
        "POS_Position": {"DR_latitude": lat, "DR_longitude": lon, "DR_speed": 0, "DR_heading": 90, "DR_distance": 0},
        "POS_CalibrationLevel": {"level": 3},  # >= 3: calibrated, no "low calibration" message
        "SEN_GPSInfo": {"latitude": lat, "longitude": lon, "height": 183, "heading": 90, "fix": 3,
                        "antennaState": 0, "satsUsed": 9, "satsVisible": 12, "signalQuality": 5,
                        "hdop": 1, "pdop": 1, "vdop": 1, "speed": 0},
        "SEN_GPSSatInfo": [],
        "SEN_ReverseGear": {"reverseValue": 0},
        "POS_VehicleSpeed": {"vehicleSpeed": 0},
    }


# Navigation.parseDbVersions keeps the whole outprop, so both versions must arrive in one frame. Until they do,
# the nav UpdateCheck holds the persistence queue, the guidance restarter waits 20 s and nav stays "not ready";
# the map controller then has no configuration and the first phone call throws #1009 in MapController.
NAV_VERSIONS = {"ETC_SoftwareVersion": "NNG 9.12.3", "ETC_DatabaseVersion": "NA_HERE;NAFTA 2015 Q1;"}


# Nav persistence (Controller/Persistence/PersistenceController.as) has its own format: write
# {"Nav_X": {"verify_key": "X", field: value...}} and read back that whole object as "res". It matches replies
# to requests by verify_key, so the generic {"value": ...} store makes every read look empty.
@on("NavigationPersistency", "write")
def nav_persist_write(dest, args, conn):
    store = H.B.PERSIST.setdefault(dest, {})
    store.update(args)
    json.dump(H.B.PERSIST, open(H.B.PERSIST_FILE, "w", encoding="utf-8"), indent=1)
    H.B.send(dest, {"write": {"res": "success"}}, conn)


@on("NavigationPersistency", "read")
def nav_persist_read(dest, args, conn):
    rec = H.B.PERSIST.get(dest, {}).get(args.get("key"))
    # Unknown key: no verify_key, which the HMI counts as an empty read and then reports as "no data".
    H.B.send(dest, {"read": {"res": rec if isinstance(rec, dict) else {}}}, conn)
    if args.get("key") == "Nav_ActGuidance":
        # Answering this ends the guidance restarter, which makes nav "ready" and creates the MapController.
        # MainBackgroundScreen only gives the map a configuration on a screen change or a display-layer change,
        # and boot's last screen change came before nav was ready. Reporting the map layer hidden (it is: no
        # map engine) fires that refresh once, as touching any screen would.
        threading.Timer(2.0, H.B.send, args=("DisplayManager", {
            "requestDisplay": {"layer": "map", "visible": "false", "granted": "true"}})).start()


@on("Navigation", "JSON_GetProperties")
def nav_get_props(dest, args, conn):
    inprop = args.get("inprop", [])
    if any(p in NAV_VERSIONS for p in inprop):
        H.B.send("Navigation", {"JSON_GetProperties": {"outprop": dict(NAV_VERSIONS)}}, conn)
    for p in inprop:
        if p in NAV_PROPS:
            H.B.send("Navigation", {"JSON_GetProperties": {"outprop": {p: NAV_PROPS[p]}}}, conn)


@on("NDR", "JSON_GetProperties")
def ndr_get_props(dest, args, conn):
    props = ndr_props()
    out = {p: props[p] for p in args.get("inprop", []) if p in props}
    H.B.send("NDR", {"JSON_GetProperties": {"outprop": out}}, conn)


@on("readPPS", "getPPSValue")
def pps_value(dest, args, conn):
    # DEST 221 = USA (VehicleMarkets -> MARKET_NORTH_AMERICA); nonzero stops the 3 s retry.
    vals = {"DEST": 221, "ECUPartNo": "68263423AE"}
    a = args.get("attribute")
    if a in vals:
        H.B.send("readPPS", {"getPPSValue": {a: vals[a]}}, conn)


def init(B):
    # MediaHomeScreen.onTrackInfo compares audioManager.getSourceType() with the media
    # device type ("usb"); without "type" the source name "usb1" is used and metadata is blanked.
    for tbl in (B.mod("Audio").get("availableAudioSources", {}),
                B.STATE.get("_replies", {}).get("Audio", {}).get("getAvailableAudioSources", {})):
        if "usb1" in tbl:
            tbl["usb1"]["type"] = "usb"
