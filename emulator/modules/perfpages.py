"""Performance Pages: the Java xlet (Sprint "gskills") can't run off the car, so the backend plays the
app manager for it and simulates the car's sensors. On the car the xlet draws on its own graphics layer
(the AMS layer) that the HMI switches on with DisplayManager.requestDisplay("ams") from AppsActiveScreen;
perfpages/app.py is that layer: a child window of the HMI window, in the xlet's screen area, drawn with the
xlet's own artwork and layout.

AppManager.as: getAppList -> {"getAppList":{"AppManager":{"appList":{"category","list"}}}}, startApp ->
operStatus "running" (HMI goes to APPS_ACTIVE), pauseApp/stopApp when the user leaves.
"""
import math, os, subprocess, sys, threading, time
import handlers as H
from handlers import on
from modules import vehicle

# The two stock xlets: "Performance Pages" (Challenger/Charger/300) and "SRT Performance Pages" (Jeep/Viper)
# and the Viper's own "SRT Performance Pages" (GSkills_Viper, 52c79381)
APPS = {"L": ("7DEC7834-535D-47B5-BD33-695477EDCD57", "Performance Pages"),
        "WK": ("6BFD02C0-40C3-11E2-A25F-0800200C9A66", "SRT Performance Pages"),
        "ZD": ("52c79381-6719-11e1-b86c-0800200c9a66", "SRT Performance Pages")}


def app():
    """(appId, name) of the xlet this car has."""
    line = vehicle.current()["line"]
    return APPS.get(line, APPS["L"])
EMU = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
PP_DIR = os.path.join(EMU, "perfpages")
APP = {"state": "stopped", "proc": None, "ams": False}

# ---------------------------------------------------------------- vehicle (modules/vehicle.py profile)
RATIOS = [4.71, 3.14, 2.11, 1.67, 1.29, 1.00, 0.84, 0.67]  # 8-speed automatic
FINAL, TIRE_M = 3.09, 0.70  # final drive, tyre diameter
G = 9.81
SIM = {"v": 0.0, "dist": 0.0, "rpm": 750.0, "gear": 1, "throttle": 0.0, "brake": 0.0, "steer": 0.0,
       "long_g": 0.0, "lat_g": 0.0, "oil_t": 60.0, "cool_t": 70.0, "trans_t": 55.0, "iat": 25.0, "ic_t": 30.0,
       "mode": "idle", "hp": 0.0, "tq": 0.0, "peak": {"left": 0.0, "right": 0.0, "accel": 0.0, "brake": 0.0}}
TIMERS = {"current": {}, "last": {}, "best": {}}
_run = {"active": False, "t0": 0.0, "brake": None}


def car():
    c = vehicle.current()
    return dict(c, boost=c["trim"] == "hellcat")


def _torque_nm(rpm, c):
    peak = c["tq"] * 1.356
    return peak * max(0.55, 1 - ((rpm - 4300) / 4300) ** 2)  # broad curve peaking ~4300 rpm


def step(dt):
    s, c = SIM, car()
    mode = s["mode"]
    s["throttle"] = {"launch": 1.0, "cruise": 0.18, "idle": 0.0, "brake": 0.0}.get(mode, 0.0)
    s["brake"] = 1.0 if mode == "brake" else 0.0
    if mode == "cruise" and s["v"] > 29:  # hold ~65 mph
        s["throttle"] = 0.08
    # driveline
    wheel_rpm = s["v"] / (math.pi * TIRE_M) * 60
    rpm = max(750.0, wheel_rpm * RATIOS[s["gear"] - 1] * FINAL)
    if rpm > c["redline"] and s["gear"] < 8:
        s["gear"] += 1
    elif s["gear"] > 1 and rpm < 1500 and s["throttle"] < 0.5:
        s["gear"] -= 1
    s["rpm"] = rpm = max(750.0, min(c["redline"], wheel_rpm * RATIOS[s["gear"] - 1] * FINAL))
    tq = _torque_nm(rpm, c) * s["throttle"]
    force = tq * RATIOS[s["gear"] - 1] * FINAL / (TIRE_M / 2) * 0.88
    force = min(force, c["mass"] * G * 0.78)  # traction limit (SRT 392: ~4.4 s 0-60, ~12.4 s 1/4)
    drag = 0.4 * s["v"] ** 2 + 180
    decel_brake = s["brake"] * 1.1 * G * c["mass"]
    a = (force - drag - (decel_brake if s["v"] > 0 else 0)) / c["mass"]
    if s["v"] <= 0 and a < 0:
        a = 0.0
    s["v"] = max(0.0, s["v"] + a * dt)
    s["dist"] += s["v"] * dt
    s["long_g"] = a / G
    s["lat_g"] = max(-1.05, min(1.05, s["v"] ** 2 * s["steer"] / 2500))  # steer -1..1
    s["tq"] = tq / 1.356
    s["hp"] = tq * rpm / 9549 * 1.341
    for k, v in (("accel", s["long_g"]), ("brake", -s["long_g"]), ("left", -s["lat_g"]), ("right", s["lat_g"])):
        s["peak"][k] = max(s["peak"][k], v)
    # temperatures creep toward load-dependent targets
    load = s["throttle"]
    for k, target, rate in (("oil_t", 100 + 25 * load, 0.02), ("cool_t", 92 + 6 * load, 0.03),
                            ("trans_t", 80 + 30 * load, 0.01), ("iat", 28 + 20 * load * c["boost"], 0.1),
                            ("ic_t", 32 + 15 * load, 0.05)):
        s[k] += (target - s[k]) * rate * dt
    timers(dt)


def timers(dt):
    s, cur = SIM, TIMERS["current"]
    mph = s["v"] * 2.23694
    if not _run["active"] and s["throttle"] > 0.5 and mph < 1:
        _run.update(active=True, t0=time.time(), d0=s["dist"])
        TIMERS["current"] = cur = {"reaction": 0.0}
    if _run["active"]:
        t, d = time.time() - _run["t0"], s["dist"] - _run["d0"]
        for key, dist in (("ft60", 18.288), ("eighth", 201.168), ("quarter", 402.336)):
            if key not in cur and d >= dist:
                cur[key] = round(t, 3)
                if key != "ft60":
                    cur[key + "_mph"] = round(mph, 1)
        for key, spd in (("et60", 60), ("et100", 100)):
            if key not in cur and mph >= spd:
                cur[key] = round(t, 3)
        if "quarter" in cur or s["throttle"] < 0.5:
            _finish()
    # braking: from >= 20 mph until stopped
    if s["brake"] > 0 and mph >= 20 and _run["brake"] is None:
        _run["brake"] = (mph, s["dist"])
    if _run["brake"] is not None and s["v"] <= 0.05:
        spd, d0 = _run["brake"]
        cur["brake_from"] = round(spd, 1)
        cur["brake_ft"] = round((s["dist"] - d0) * 3.28084, 1)
        _run["brake"] = None
        _finish()


def _finish():
    if _run["active"] or TIMERS["current"]:
        _run["active"] = False
        TIMERS["last"] = dict(TIMERS["current"])
        best = TIMERS["best"]
        for k, v in TIMERS["current"].items():
            lower_better = not k.endswith(("_mph", "_from"))
            if k not in best or (v < best[k] if lower_better else v > best[k]):
                best[k] = v


def sim_loop():
    last = time.time()
    while True:
        time.sleep(0.05)
        now = time.time()
        step(min(0.1, now - last))
        last = now


# ---------------------------------------------------------------- data for the overlay
def _units():
    pc = H.B.prop_store("PersonalConfig")
    return "METRIC" if str(pc.get("temperatureUnits", "US")).upper() == "METRIC" else "US"


def api_perf():
    s, c = SIM, car()
    return {"visible": APP["state"] == "running" and APP["ams"], "trim": c["trim"], "line": c["line"].lower(),
            "units": _units(), "trans": c["trans"],
            # the app's pages are see-through: the head unit's theme wallpaper shows behind them
            "theme": H.json.load(open(H.CONFIG_FILE, encoding="utf-8")).get("theme", ""),
            "speed_mph": s["v"] * 2.23694, "rpm": s["rpm"], "gear": s["gear"], "hp": s["hp"], "tq": s["tq"],
            "oil_p_kpa": min(650.0, 120 + s["rpm"] * 0.075), "oil_t": s["oil_t"], "cool_t": s["cool_t"],
            "trans_t": s["trans_t"], "iat": s["iat"], "ic_t": s["ic_t"], "batt": 14.1 + 0.1 * math.sin(time.time()),
            # absolute manifold pressure like the xlet's 0-250 kPa gauge: ~35 kPa vacuum at idle, ~11.6 psi boost
            "boost_kpa": 35 + (101.3 - 35 + 80 * min(1, s["rpm"] / 4000)) * s["throttle"] if c["boost"] else 0.0,
            "afr": 14.7 - 3.2 * s["throttle"], "long_g": s["long_g"], "lat_g": s["lat_g"],
            "steer_deg": s["steer"] * 90, "peak": s["peak"], "timers": TIMERS, "mode": s["mode"]}


def perf_action(value):
    """Panel: launch | cruise | brake | idle | left | straight | right | reset."""
    if value in ("left", "straight", "right"):
        SIM["steer"] = {"left": -1.0, "straight": 0.0, "right": 1.0}[value]
    elif value == "reset":
        SIM["peak"] = {k: 0.0 for k in SIM["peak"]}
        TIMERS.update(current={}, last={}, best={})
    elif value in ("launch", "cruise", "brake", "idle"):
        SIM["mode"] = value


# ---------------------------------------------------------------- AppManager
def _app_entry():
    # Names use the xlet.properties format AppXlet.parseLanguages splits: "lang:text,lang:text"
    app_id, name = app()
    return {"xlet.name": name, "xlet.appId": app_id, "isFavorite": False, "isEmbeddedApp": False,
            "shortName": "en_US:Perform", "medName": "en_US:Perform\nPages", "nameString": "en_US:" + name}


def _am(payload, conn=None):
    H.B.send("AppManager", payload, conn)


def _oper(state):
    APP["state"] = state
    _am({"operStatus": {"appId": app()[0], "name": app()[1], "state": state, "type": "gui",
                        "daemon": False, "hasGUI": True}})


@on("AppManager", "getAppManagerStatus")
def am_status(dest, args, conn):
    _am({"getAppManagerStatus": {"status": "Ready"}}, conn)


@on("AppManager", "getXletsDir")
def am_xlets_dir(dest, args, conn):
    # AppXlet checks <xletsDir>/xlets/<appId>/data/onIcon.png with File.resolvePath (needs a native path),
    # then loads it as "file://" + that path.
    _am({"getXletsDir": {"xletsDir": PP_DIR.replace("\\", "/")}}, conn)


@on("AppManager", "getAppList")
def am_app_list(dest, args, conn):
    cat = int(args.get("category", -2))
    lst = [] if (cat == -3 and APP["state"] != "running") or not vehicle.current()["perfPages"] else [_app_entry()]
    _am({"getAppList": {"AppManager": {"appList": {"category": cat, "list": lst}}}}, conn)


@on("DisplayManager", "requestDisplay")
def dm_request_display(dest, args, conn):
    if args.get("requester") == "ams":  # AppsActiveScreen in/out: the app layer shows/hides
        APP["ams"] = str(args.get("value")) == "true"


@on("AppManager", "startDaemonApp")  # Drive Modes > "SRT Pages"
@on("AppManager", "startApp")
def am_start(dest, args, conn):
    app_id = app()[0]
    if args.get("appId") != app_id:
        return _am({"startApp": {"errorCode": 1}}, conn)
    _am({"startApp": {"errorCode": 0}}, conn)
    _ensure_overlay()
    _am({"appStarted": {"appId": app_id, "errorCode": 0}})
    # The app service asks the HMI to show the app first (HMIRequest.setAppVisible -> mIsAppMainScreen);
    # without it the HMI answers "running" with an immediate pauseApp.
    _am({"setAppVisible": {"appId": app_id, "visible": True}})
    _oper("running")


@on("AppManager", "pauseApp")
def am_pause(dest, args, conn):
    if args.get("appId") == app()[0]:
        _oper("paused")


@on("AppManager", "stopApp")
def am_stop(dest, args, conn):
    if args.get("appId") == app()[0]:
        _oper("stopped")


def _hmi_title():  # the layer finds its parent window by this title
    inst = os.environ.get("UC_INSTANCE_DIR")
    return f"Uconnect dev: {os.path.basename(inst)}" if inst else "Uconnect 8.4AN (RA4 17.43.01)"


def _ensure_overlay():
    p = APP["proc"]
    if p is None or p.poll() is not None:
        APP["proc"] = subprocess.Popen([sys.executable, os.path.join(PP_DIR, "app.py"), _hmi_title(), str(H.B.PANEL_PORT)])


def init(B):
    B.API["/api/perf"] = api_perf
    H.PANEL_ACTIONS["perf"] = perf_action
    threading.Thread(target=sim_loop, daemon=True).start()
