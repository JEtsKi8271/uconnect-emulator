"""SRT Drive Modes: the car side of the stock DriveMode screens (DriveMode.as).

L-series cars (Challenger/Charger/300) use the "legacy" table mode: one settings table per drive mode.
The Jeep Grand Cherokee SRT (WK, Selec-Track) is non-legacy: the mode comes from the console dial, the HMI's
Set-Up edits one custom set (the *DriveMode / *Cfg signals) that Custom, and partly Auto/Snow/Tow, use.

The HMI only offers Drive Modes when VehicleConfig has driveModePresent + SRTPresent (state.json),
then asks this module for every signal. A mode change sends globalDriveModeStatus; the HMI expects
each subsystem's status signal back (it times out into an error otherwise), so every change replies
with the whole picture. Values on the wire are the Lua names ("street", "red", "paddles_enabled").
"""
import copy
import handlers as H
from handlers import on
from modules import vehicle

SUBSYS = ("transmissionDriveMode", "HPDriveModeCfg", "EPSDriveMode", "ESCDriveMode",
          "activeDampingDriveMode", "paddlesDriveMode", "terrainDriveMode", "engineDriveModeCfg")
# subsystem setting -> the live status signal it drives
STATUS = {"transmissionDriveMode": "transmissionMode", "HPDriveModeCfg": "enginePowerMode",
          "EPSDriveMode": "EPSModeStatus", "ESCDriveMode": "ESCButtonStatus",
          "activeDampingDriveMode": "activeDampingStatus", "paddlesDriveMode": "paddlesDriveModeStatus",
          "terrainDriveMode": "terrainMode", "engineDriveModeCfg": "engineDriveMode"}
# factory tables; terrain (AWD torque split) only shows on the Jeep: auto 40/60, sport 35/65, track 30/70, snow 50/50.
# Last column: the engine/throttle setting of non-SRT "Performance Control" cars (manual: no transmission row).
TABLES = {
    "default": ["street", "black", "street", "street", "street", "paddles_disabled", "auto", "street"],
    "sport": ["sport", "red", "sport", "sport", "sport", "paddles_enabled", "sport", "sport"],
    "track": ["track", "red", "track", "track", "track", "paddles_enabled", "track", "sport"],
    "snow": ["snow", "black", "street", "snow", "street", "paddles_disabled", "snow", "street"],
    "tow": ["tow", "black", "street", "street", "street", "paddles_disabled", "tow", "street"],
    "custom": ["sport", "red", "street", "sport", "street", "paddles_enabled", "sport", "sport"],
}
# Jeep: what the Set-Up screen may change in each dial position comes from the one custom set
# (DriveModeWKSetup: Auto -> paddles/steering/suspension; Snow/Tow -> paddles)
WK_FROM_CUSTOM = {"default": ("paddlesDriveMode", "EPSDriveMode", "activeDampingDriveMode"),
                  "snow": ("paddlesDriveMode",), "tow": ("paddlesDriveMode",), "custom": SUBSYS}
CAR = {"mode": "default", "eco": False, "launch": "off", "launchRPM": None, "shift": "enabled",
       "tables": {m: dict(zip(SUBSYS, v)) for m, v in TABLES.items()}}
FACTORY = copy.deepcopy(CAR["tables"])

FIXED = {"ready": "true", "isLegacyDriveMode": "true", "redKeyFeaturePresent": "true", "redKeyPresent": "true",
         "powerSteeringType": "EPS", "EPSWarnDisplayRequest": "none", "throttlePosition": "released",
         "valetLockOut": "false", "SRTButtonStatus": "off", "tractionControlIndicator": "on",  # on = traction control on
         "maxShiftRPM": "6200", "gear1RPMSetPoint": "6000", "gear2RPMSetPoint": "6000", "gear3RPMSetPoint": "6000",
         "gear4RPMSetPoint": "6000", "gear5RPMSetPoint": "6000", "shiftIndicatorRPMReset": "false",
         **{f"driveModeIndicator{i}": "false" for i in range(1, 5)}, **{f"ErrSys_{i}": "false" for i in range(1, 9)}}


def wk():
    return vehicle.current()["line"] == "WK"


def props():
    hellcat = vehicle.current()["trim"] == "hellcat"
    FIXED["isLegacyDriveMode"] = "false" if wk() else "true"
    FIXED["redKeyFeaturePresent"] = "true" if hellcat else "false"
    if not hellcat:
        FIXED["redKeyPresent"] = "false"
    drop = "HPDriveModeCfg" if not vehicle.current().get("srt", True) else "engineDriveModeCfg"
    mode = CAR["mode"]
    live = dict(CAR["tables"]["default" if mode == "valet" else mode])
    if wk():
        live.update({k: CAR["tables"]["custom"][k] for k in WK_FROM_CUSTOM.get(mode, ())})
    p = dict(FIXED, globalDriveModeStatus=mode, ecoModeActive=str(CAR["eco"]).lower(),
             launchButtonStatus=CAR["launch"],
             launchRPMSetPoint=CAR["launchRPM"] or ("1500" if vehicle.current()["trans"] == "Automatic" else "2500"),
             shiftIndicatorStatus=CAR["shift"], driveModeIndicator3=str(CAR["launch"] == "on").lower(),
             # both power columns land on the HORSE_POWER slot (DriveMode.createTable): send only this car's one
             globalDriveModeConfigs={m: {"values": {k: v for k, v in t.items() if k != drop}}
                                     for m, t in CAR["tables"].items()})
    for k in SUBSYS:
        p[k] = CAR["tables"]["custom"][k]
        p[STATUS[k]] = live[k]
    if mode == "valet":  # valet: 500 hp, street everything, no paddles
        p.update(enginePowerMode="valet", transmissionMode="street", paddlesDriveModeStatus="paddles_disabled")
    return p


def push(conn=None, keys=None):
    p = props()
    # getProperties is the one reply shape processProperties takes as {signal: raw value}
    H.B.send("DriveMode", {"getProperties": {k: p[k] for k in (keys or p)}}, conn)


@on("DriveMode", "getAllProperties")
def dm_all(dest, args, conn):
    H.B.send("DriveMode", {"getAllProperties": props()}, conn)


@on("DriveMode", "getProperties")
def dm_get(dest, args, conn):
    p = props()
    push(conn, [k for k in args.get("props", []) if k in p])


@on("DriveMode", "getDriveModeVersion")
def dm_version(dest, args, conn):
    H.B.send("DriveMode", {"getDriveModeVersion": {"version": "DM 2.0"}}, conn)


@on("DriveMode", "getLoggingEnable")
def dm_logging(dest, args, conn):
    H.B.send("DriveMode", {"getLoggingEnable": {"enableLogging": "false"}}, conn)


@on("DriveMode", "setLoggingEnable")
def dm_set_logging(dest, args, conn):
    H.B.send("DriveMode", {"getLoggingEnable": {"enableLogging": str(args.get("value", "false"))}}, conn)


@on("DriveMode", "copyDriveModeLogToUSB")
def dm_copy_log(dest, args, conn):
    pass  # no USB stick on a PC; the HMI shows no result for this


@on("DriveMode", "setProperties")
def dm_set(dest, args, conn):
    for k, v in (args.get("props") or {}).items():
        set_prop(k, v)
    save()
    push()


# Like the car: custom/mode tables, launch and shift-light settings survive an ignition cycle; the drive mode
# itself comes back as Default.
KEEP = ("tables", "launchRPM", "shift")


def save():
    H.update_config(driveMode={**{k: CAR[k] for k in KEEP},
                               "gearRPM": {k: v for k, v in FIXED.items() if k.endswith("RPMSetPoint")}})


def load():
    saved = H.json.load(open(H.CONFIG_FILE, encoding="utf-8")).get("driveMode", {})
    CAR.update({k: saved[k] for k in KEEP if k in saved and k != "tables"})
    for m, t in saved.get("tables", {}).items():  # over the factory tables: older saves lack newer columns
        CAR["tables"].setdefault(m, {}).update(t)
    FIXED.update(saved.get("gearRPM", {}))


def set_prop(key, val):
    # Subsystem requests arrive as {"type": <global mode>, "value": <setting>} (DriveMode.convertReq*)
    mode, val = (val.get("type") or CAR["mode"], val.get("value")) if isinstance(val, dict) else (CAR["mode"], val)
    if key == "globalDriveModeStatus":
        CAR["mode"] = "default" if val == "valet" and CAR["mode"] == "valet" else val
        if CAR["mode"] == "valet":
            CAR["launch"] = "off"
        if val in ("sport", "track"):
            CAR["eco"] = False
    elif key in STATUS.values() or key in SUBSYS:
        sub = key if key in SUBSYS else next(s for s, st in STATUS.items() if st == key)
        CAR["tables"].setdefault("custom" if wk() else mode, {})[sub] = val
    elif key == "launchButtonStatus":  # a button press: the same "on" arms and cancels
        CAR["launch"] = "off" if CAR["launch"] == "on" or CAR["mode"] == "valet" else "on"
    elif key == "launchRPMSetPoint":
        CAR["launchRPM"] = str(val)
    elif key == "shiftIndicatorStatus":
        CAR["shift"] = val if val in ("enabled", "disabled") else CAR["shift"]
    elif key == "shiftIndicatorRPMReset":
        for g in range(1, 6):
            FIXED[f"gear{g}RPMSetPoint"] = "6000"
    elif key.endswith("RPMSetPoint"):
        FIXED[key] = str(val)
    else:
        H.B.log("DM", f"unhandled setProperties {key}={val}")


def on_emit(packet):
    if "ecoModeActiveRequest" in packet:  # Eco button on the main screen
        CAR["eco"] = packet["ecoModeActiveRequest"].get("value") == "true"
        if CAR["eco"]:
            CAR["mode"] = "default"
        push()


def dm_action(value):
    """Panel: srt (SRT button) | redkey | blackkey | reset | selec:<auto|sport|track|snow|tow> (Jeep dial)."""
    if value == "srt":
        H.hard_key("srt")
    elif value.startswith("selec:"):  # Selec-Track: the car changes mode and tells the head unit
        pos = value.split(":", 1)[1]
        if pos not in ("auto", "sport", "track", "snow", "tow"):
            raise ValueError(value)
        CAR["mode"] = "default" if pos == "auto" else pos
        CAR["launch"] = "off"
        push()
    elif value in ("redkey", "blackkey"):
        FIXED["redKeyPresent"] = "true" if value == "redkey" else "false"
        if value == "blackkey":
            for t in CAR["tables"].values():
                t["HPDriveModeCfg"] = "black"
        push()
    elif value == "reset":
        CAR["tables"] = copy.deepcopy(FACTORY)
        CAR.update(mode="default", eco=False, launch="off", launchRPM=None)
        save()
        push()


def init(B):
    load()
    H.PANEL_ACTIONS["drivemode"] = dm_action
    H.EMIT_HOOKS.append(on_emit)
