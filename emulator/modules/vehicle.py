"""Which car the head unit is in. The profile (config.json "vehicle") becomes VehicleConfig at backend start,
which is what decides, in the stock HMI, whether SRT Drive Modes / Performance Pages exist, the SRT theme list,
the Hellcat launch dial, the Performance Pages car pictures and gauges, and so on.

Panel action "vehicle": {"model", "trans", "perfPages", "driveModes"} -> saved (with that car's theme and boot
splash when the car changes), then the head unit restarts (the HMI reads VehicleConfig once at boot, like the car).
"""
import json
import handlers as H

# line: LA Challenger, LD Charger, LX 300, WK Grand Cherokee (Performance Pages artwork + HMI VehicleConfig names).
# theme/splash: what the car boots with. Themes are from the stock SRT set (themes.xml "SRT 1"-"SRT 6"):
# 156 red honeycomb, 157 Hellcat logo, 160 graphite carbon, 161 blue carbon (the LX/WK Performance Pages blue).
PROFILES = {
    "challenger_hellcat": {"name": "Dodge Challenger SRT Hellcat", "line": "LA", "brand": 2, "trim": "hellcat",
                           "hp": 707, "tq": 650, "redline": 6200, "mass": 2000,
                           "theme": "SRT/157_SRT.swf", "splash": "SRT.png"},
    "challenger_srt": {"name": "Dodge Challenger SRT 392", "line": "LA", "brand": 2, "trim": "srt",
                       "hp": 485, "tq": 475, "redline": 6400, "mass": 1900,
                       "theme": "SRT/156_SRT.swf", "splash": "SRT.png"},
    "charger_hellcat": {"name": "Dodge Charger SRT Hellcat", "line": "LD", "brand": 2, "trim": "hellcat",
                        "hp": 707, "tq": 650, "redline": 6200, "mass": 2075,
                        "theme": "SRT/157_SRT.swf", "splash": "SRT.png"},
    "charger_srt": {"name": "Dodge Charger SRT 392", "line": "LD", "brand": 2, "trim": "srt",
                    "hp": 485, "tq": 475, "redline": 6400, "mass": 1950,
                    "theme": "SRT/156_SRT.swf", "splash": "SRT.png"},
    "300_srt": {"name": "Chrysler 300 SRT", "line": "LX", "brand": 1, "trim": "srt",
                "hp": 470, "tq": 470, "redline": 6400, "mass": 1950,
                "theme": "SRT/160_SRT.swf", "splash": "chrysler.png"},
    "grand_cherokee_srt": {"name": "Jeep Grand Cherokee SRT", "line": "WK", "brand": 3, "trim": "srt",
                           "hp": 475, "tq": 470, "redline": 6400, "mass": 2350, "autoOnly": True,
                           "theme": "SRT/161_SRT.swf", "splash": "Jeep.png"},
    # The Viper (ZD): its own theme list and its own SRT Performance Pages app (52c79381); no SRT Drive Modes.
    "viper": {"name": "Dodge Viper SRT", "line": "ZD", "brand": 2, "trim": "srt", "hp": 645, "tq": 600,
              "redline": 6200, "mass": 1500, "manualOnly": True, "noDriveModes": True,
              "theme": "Viper/146_Viper.swf", "splash": "SRT.png"},
}
# Non-SRT cars: the head unit then offers that brand's own themes (SettingsThemeScreen) and boots its splash.
for _key, (_name, _brand, _line, _folder, _theme, _splash) in {
        "dodge": ("Dodge (non-SRT)", 2, "LD", "Dodge", "006_Dodge.swf", "dodge.png"),
        "chrysler": ("Chrysler (non-SRT)", 1, "LX", "Chrysler", "106_Chrysler.swf", "chrysler.png"),
        "jeep": ("Jeep (non-SRT)", 3, "WK", "Jeep", "056_Jeep.swf", "Jeep.png"),
        "ram": ("Ram", 12, "DS", "Ram", "136_Ram.swf", "RAM.png"),
        "fiat": ("Fiat", 9, "", "Fiat", "176_Fiat.swf", "fiat.png"),
        "maserati": ("Maserati", 11, "", "Maserati", "186_Maserati.swf", "Maserati.png"),
        "lancia": ("Lancia", 10, "", "Lancia", "216_Lancia.swf", "lancia.png")}.items():
    PROFILES[_key] = {"name": _name, "line": _line, "brand": _brand, "trim": "base", "hp": 300, "tq": 300,
                      "redline": 6000, "mass": 1900, "srt": False, "noSrtApps": True,
                      "theme": f"{_folder}/{_theme}", "splash": _splash}
# R/T and Scat Pack: "Dodge/Chrysler Performance Control" (Default/Sport, Launch Control) + R/T Performance Pages
for _key, (_name, _brand, _line, _hp, _tq, _theme, _splash) in {
        "challenger_rt": ("Dodge Challenger R/T", 2, "LA", 375, 410, "Dodge/006_Dodge.swf", "dodge.png"),
        "challenger_scatpack": ("Dodge Challenger R/T Scat Pack", 2, "LA", 485, 475, "Dodge/007_Dodge.swf", "dodge.png"),
        "charger_rt": ("Dodge Charger R/T", 2, "LD", 370, 395, "Dodge/006_Dodge.swf", "dodge.png"),
        "charger_scatpack": ("Dodge Charger R/T Scat Pack", 2, "LD", 485, 475, "Dodge/007_Dodge.swf", "dodge.png"),
        "300s": ("Chrysler 300S", 1, "LX", 363, 394, "Chrysler/106_Chrysler.swf", "chrysler.png")}.items():
    PROFILES[_key] = {"name": _name, "line": _line, "brand": _brand, "trim": "rt", "hp": _hp, "tq": _tq,
                      "redline": 6200, "mass": 1900, "srt": False, "theme": _theme, "splash": _splash}
THEME_BRANDS = {1: "Chrysler", 2: "Dodge", 3: "Jeep", 8: "AlfaRomeo", 9: "Fiat", 10: "Lancia", 11: "Maserati", 12: "Ram"}


def theme_brand(v=None):
    """The themes.xml brand the head unit lists in Settings > Theme for this car (SettingsThemeScreen.initView)."""
    v = v or current()
    if v.get("srt", True) and v["line"] != "ZD":
        return "SRT"
    if v["line"] == "ZD":
        return "Viper"
    return THEME_BRANDS.get(v["brand"], "Default")
DEFAULT = {"model": "challenger_hellcat", "trans": "Automatic", "perfPages": True, "driveModes": True}


def settings():
    c = json.load(open(H.CONFIG_FILE, encoding="utf-8"))
    v = dict(DEFAULT, **c.get("vehicle", {}))
    if v["model"] not in PROFILES:
        v["model"] = DEFAULT["model"]
    return v


def current():
    """Profile dict plus the options, e.g. current()["trim"], current()["trans"]."""
    v = settings()
    c = dict(PROFILES[v["model"]], **v)
    if c.get("autoOnly"):  # the Grand Cherokee SRT only came with the 8-speed automatic
        c["trans"] = "Automatic"
    if c.get("manualOnly"):  # the Viper: 6-speed manual only
        c["trans"] = "Manual"
    if c.get("noSrtApps"):  # no Drive Modes / Performance Pages for this car in the firmware
        c["perfPages"] = c["driveModes"] = False
    if c.get("noDriveModes"):
        c["driveModes"] = False
    return c


def apply(B):
    v = current()
    hellcat, auto = v["trim"] == "hellcat", v["trans"] == "Automatic"
    yes = lambda b: "true" if b else "false"
    B.prop_store("VehicleConfig").update({
        "vehiclePlatform": v["line"], "vehicleBrand": str(v["brand"]),
        "SRTPresent": yes(v.get("srt", True)), "driveModePresent": yes(v["driveModes"]),
        # non-SRT cars get Drive Modes as "<brand> Performance Control" (DriveModeManager: sport mode + perf pages,
        # and with legacy tables the Super Track Pack flag)
        "sportModePresent": yes(v["driveModes"]), "superTrackPackPresent": yes(v["driveModes"] and not v.get("srt", True)),
        "performancePagesPresent": yes(v["perfPages"]),
        "engPowerDrvMdPresent": yes(hellcat), "redKeyPresent": yes(hellcat),
        "transEquipped": v["trans"], "transDrvMdPresent": yes(auto), "paddlesModePresent": yes(auto),
        "shiftIndicatorType": "" if auto else "PSI",  # manual cars get the shift light (Race Options)
        "ESCDrvMdPresent": "true", "ADCM_Present": yes(v.get("srt", True)),  # adaptive dampers: SRT only
        "EPS_Present": yes(v["line"] != "LX"),  # the 300 SRT keeps hydraulic steering
        # Jeep: Selec-Track dial (TSBM), drive mode version 2, Quadra-Trac SRT transfer case (AWD row)
        "TSBMPresent": yes(v["line"] == "WK"), "driveModeVersion": "Version_2" if v["line"] == "WK" else "",
        "TcaseType": "Tcase_156" if v["line"] == "WK" else "",
    })


def _sync_brand(model_changed):
    """Brand byte always; on a different car also that car's theme and boot splash. Re-applying the same car
    keeps a theme/splash picked since (head unit Settings > Theme, or the panel)."""
    c = json.load(open(H.CONFIG_FILE, encoding="utf-8"))
    v = current()
    srt_bit = 1 if v.get("srt", True) else 0  # splash flags bit 0 = SRT package (splash.lua)
    kv = {"brandId": v["brand"], "splashFlags": (c.get("splashFlags", 0) & ~1) | srt_bit}
    if model_changed:
        kv.update(theme=v["theme"], splash=v["splash"])
    H.update_config(**kv)


def vehicle_action(value):
    v = json.loads(value) if isinstance(value, str) else value
    cur = settings()
    had = json.load(open(H.CONFIG_FILE, encoding="utf-8")).get("vehicle", {}).get("model")
    if v.get("model", cur["model"]) not in PROFILES or v.get("trans", cur["trans"]) not in ("Automatic", "Manual"):
        raise ValueError(value)
    cur.update({k: v[k] for k in DEFAULT if k in v})
    H.update_config(vehicle=cur)
    _sync_brand(cur["model"] != had)
    apply(H.B)  # the backend keeps running; only the HMI restarts
    H.restart_hmi()


def api_vehicle():
    return {"settings": settings(), "models": {k: p["name"] for k, p in PROFILES.items()}, "themeBrand": theme_brand()}


def init(B):
    apply(B)
    B.API["/api/vehicle"] = api_vehicle
    H.PANEL_ACTIONS["vehicle"] = vehicle_action
