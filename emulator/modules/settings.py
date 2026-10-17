"""Settings + Controls: PersonalConfig (vehicle/display/units personal settings), VehSetting
(heated/vented seats, heated wheel), VehicleStatus (park / speed lockout), AudioSettings
(EQ, balance/fade, speed-adjusted volume, surround), Clock (manual time, 12/24h) and the
"platform" service (System Information versions, restore defaults).

Shapes come from com/nfuzion/moduleLink/{PersonalConfig,VehSettings,AudioSettings,Clock}.as and
com/harman/moduleLink/{VehicleStatus,VersionInfo}.as in MainSupplement.
"""
import calendar, copy, json, os, time
import handlers as H
from handlers import on

_EMU = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SAVE_FILE = os.path.join(os.environ.get("UC_INSTANCE_DIR", _EMU), "settings.json")
VERSION_FILE = os.path.join(_EMU, "..", "extracted", "primary", "etc", "version.txt")

# ---------------------------------------------------------------- PersonalConfig
# Raw property values (getAllProperties). Strings/ints/bools exactly as the AS3 members expect;
# where the AS3 declares no default we pick what a 2015 Dodge leaves the factory with.
UNIT_SETS = {
    "us": {"speedUnits": "mph", "distanceUnits": "miles", "fuelConsumpUnits": "mpg_us", "capacityUnits": "gal_us",
           "pressureUnits": "psi", "temperatureUnits": "US", "horsepowerUnits": "hp_us", "torqueUnits": "lb-ft"},
    "metric": {"speedUnits": "kph", "distanceUnits": "km", "fuelConsumpUnits": "L100km", "capacityUnits": "Liters",
               "pressureUnits": "kPa", "temperatureUnits": "METRIC", "horsepowerUnits": "kW", "torqueUnits": "Nm"},
}
PC_DEFAULTS = dict(UNIT_SETS["us"], **{
    # display
    "displayMode": "day", "displayModeSetting": "auto", "maxDisplayBrightnessLevel": 10,
    "brightnessHeadlightsOn": 5, "brightnessHeadlightsOff": 10, "color": "bold", "lang": "english",
    "units": "us", "voiceResLen": "brief", "touchScreenBeep": True, "navCluster": True, "fuelSaveDisp": True,
    "controlsTimeoutEnabled": True, "readyToDriveStatus": True, "enablePhoneRepetition": False,
    "teleprompterMode": "always", "navRepetitionEnabled": False,
    # safety & driving assistance
    "collisionSens": "far", "fcwSensitivitySetting": "med", "fcwOnOffState": "on", "fcwBrakeStatus": "on",
    "parkAssist": "sounddisplay", "frontSensorsActiveDrive": "off", "frontParkAssistChimeVol": "medium",
    "rearParkAssistChimeVol": "medium", "rearParkAssistBraking": True, "sideDistanceWarning": "off",
    "sideDistanceWarningChimeVolume": "low", "tilt": True, "blindSpotAlert": "lights", "parkviewCam": True,
    "parkviewCamDelay": False, "parkviewDynamicGridLines": True, "parkviewStaticGridLines": True,
    "surroundCamLock": False, "rainWipers": True, "hillAssist": True, "powerSteeringMode": "Normal",
    "powerFoldingMirrors": False, "laneDepartureWarnSetting": False, "laneSenseWarnSensitivity": "Med",
    "laneSenseTorqueIntensity": "Med", "svcDynamicGridLines": True, "svcDelay": False,
    "chmslCameraGuidelines": False, "paddlesModeStatus": "none",
    # lights
    "headlightOff": 30, "headlightIllum": 30, "headlightWiper": True, "autoDimHiBeam": True,
    "daytimeLights": True, "steeringLights": False, "headlightDip": False, "headlightsLock": True,
    "moodLightingInts": "off", "ambientLightingLevel": "1", "externalLightSensorLevel": 0,
    "corneringEnable": False, "greetingLightsEnable": False,
    # doors & locks
    "autoLock": True, "autoUnlock": True, "flashHeadlightLock": True, "soundHornLock": False,
    "soundHornLock1st2nd": "off", "soundHornRemote": False, "keyUnlock": "driverdoor", "passiveEntry": True,
    "personalSettingsLinked": True, "slidingDoorAlert": False, "slidingDoorStatus": False,
    "flashLightSlideDoorStatus": False, "autoRelock": True, "hornRemoteStart": False,
    "pwrLiftgateChime": False, "pwrLiftgateStatus": False,
    # comfort / engine off
    "autoOnDCS": "off", "exitSeat": True, "engineOffDelay": 0, "offWithDoorOpen": True, "compassVariance": 1,
    # suspension / brakes / trailer (hidden on this car, but never blank)
    "soundHornRemoteLower": False, "flashLightLower": False, "suspensionMessages": True, "tireJackMode": False,
    "transportMode": False, "aeroMode": True, "easyExitSuspension": True, "wheelAlignment": False,
    "autoParkBrakeStatus": "on", "autoBrakeHoldStatus": "on", "brakeServiceStatus": False,
    "brakeServiceTextDisplay": "0", "resetTripA": "noAck", "resetTripB": "noAck", "trlrNum": 0,
    "itbmBrkStyle": -1, "trlr1BrkStyle": -1, "trlr2BrkStyle": -1, "trlr3BrkStyle": -1, "trlr4BrkStyle": -1,
    "trlrStyle": "none", "trlr1Style": "none", "trlr2Style": "none", "trlr3Style": "none", "trlr4Style": "none",
    "dnaEnable": False, "autoSwitch": "recall_last", "videoReadBack": False,
    # teen key (KeySense)
    "teenKeyFCWSensitivitySetting": "off", "teenKeyFCWBrakingAssistStatus": "off", "teenKeyPTS_ConfigStatus": "off",
    "teenKeyPTS_BrakingAssistStatus": False, "teenKeyPTS_FrontVolume": "medium", "teenKeyPTS_RearVolume": "medium",
    "teenKeyBSM_ConfigStatus": "off", "teenKeyFuelPopupStatus": False, "teenKeyEarlyFuelWarningStatus": False,
    "teenKeyPwrLiftgateChimeStatus": False, "teenKeySlidingDoorAlertStatus": False, "teenKeyAutoWiperStatus": False,
    "teenKeyHLsWithWiperStatus": False, "teenKeyAutoHighBeamsStatus": False, "teenKeyMaxSpeedLimit": "not_set",
})
# Custom unit set shown by getCustomUnitProperties (what "custom" switches to).
CUSTOM_UNITS = dict(UNIT_SETS["metric"], temperatureUnits="US")

# VehicleConfig flags this area needs that state.json lacks (or has in the wrong form: the
# FCW / park-assist / rain-sensor / gridline flags are option strings, not "true").
VEHCFG = {
    "forwardCollisionWarningPresent": "3option", "forwardCollisionBrakingPresent": "true",
    "fcwOnOffSoftKeyPresent": "false", "parkAssistPresent": "3option", "parkAssistBrakingPresent": "true",
    "parkAssistFrontVolumePresent": "true", "parkAssistRearVolumePresent": "true", "rainSensorPresent": "1option",
    "rearCameraGridType": "both", "rearCameraDelayPresent": "true", "tiltMirrorInReversePresent": "true",
    "laneSenseSensitivityType": "absent", "laneSenseTorqueType": "absent",
    "autoDriverComfortPresent": "true", "autoOnFeatureMethod": "3option",
    "headlampOffDelayPresent": "true", "illuminatedApproachPresent": "true", "flashLampWithLockPresent": "true",
    "autoDoorUnlockPresent": "true", "accessoryDelayPresent": "true", "easySeatExitPresent": "true",
    "unitSetPresent": "true", "speedUnitsPresent": "true", "distanceUnitsPresent": "true",
    "consumptionUnitsPresent": "true", "capacityUnitsPresent": "true", "pressureUnitsPresent": "true",
    "temperatureUnitsPresent": "true", "powerUnitsPresent": "true", "torqueUnitsPresent": "true",
    "surroundSoundPresent": "true", "setDatePresent": "true", "compassVariancePresent": "false",
}

# ---------------------------------------------------------------- VehSetting (Controls)
# getAllProperties: the presence of a key is what enables its Controls button. No "screenEnable":
# true there means "screen-off switch pressed" and blanks the display (HardControls.onScreenEnable).
VEH = {"ready": "true", "comfortFeaturesDisabled": False,
       "heatSeatFrontLeft": "off", "heatSeatFrontRight": "off", "ventSeatFrontLeft": "off",
       "ventSeatFrontRight": "off", "heatWheel": "off",
       "heatSeatFLFailPrsnt": False, "heatSeatFRFailPrsnt": False, "ventSeatFLFailPrsnt": False,
       "ventSeatFRFailPrsnt": False, "heatWheelFailPrsnt": False}
# A seat cannot heat and cool at once: turning one on turns its partner off (as the car does).
SEAT_PARTNER = {"heatSeatFrontLeft": "ventSeatFrontLeft", "ventSeatFrontLeft": "heatSeatFrontLeft",
                "heatSeatFrontRight": "ventSeatFrontRight", "ventSeatFrontRight": "heatSeatFrontRight"}

# ---------------------------------------------------------------- VehicleStatus
# Parked, not speed-locked: every settings menu is usable.
VSTATUS = {"speedLockOut": "disabled", "vehicleInPark": "true", "speedLockOutFeature": "on",
           "headlightsOn": False, "language": "en_US", "testToolPresent": False, "themeFileOverride": "off",
           "selecTerrainModeStatus": False, "langUnitMstrOverride": "off", "fuelSaverModeActual": "na",
           "TeenKeyIsPresent": False, "resumeModeTimeout": 0, "vehicleInMotion": False,
           "EPBServiceActivePopup": False, "rearCameraSpeedDelay": False, "KeySenseTimerValue": 0}

# ---------------------------------------------------------------- AudioSettings / Clock
AUDIO_DEFAULTS = {"bass": 0, "mid": 0, "treble": 0, "balance": 0, "fade": 0, "loudness": False,
                  "speedOn": True, "variance": 2, "surround": False}
AUDIO = dict(AUDIO_DEFAULTS)
CLOCK_DEFAULTS = {"timeFormat24": False, "enableClock": True, "daylightSavings": False, "gpsTime": False}
CLOCK = {"offset": 0}  # seconds the user moved the clock away from the PC clock


def save():
    data = {"PersonalConfig": H.B.prop_store("PersonalConfig"), "Clock": H.B.prop_store("Clock"),
            "clockOffset": CLOCK["offset"], "AudioSettings": AUDIO}
    with open(SAVE_FILE, "w", encoding="utf-8") as f:
        json.dump(data, f, indent=1)


def _props(args):
    return args.get("props") if isinstance(args.get("props"), dict) else args


def pc_set(key, value):
    H.B.set_property("PersonalConfig", key, value)


@on("PersonalConfig", "setProperties")
def pc_set_props(dest, args, conn):
    for k, v in _props(args).items():
        pc_set(k, v)
        # The real service rewrites every unit when the unit system changes.
        if k == "units":
            for uk, uv in (CUSTOM_UNITS if v == "custom" else UNIT_SETS.get(v, UNIT_SETS["us"])).items():
                pc_set(uk, uv)
    save()


@on("PersonalConfig", "getCustomUnitProperties")
def pc_custom_units(dest, args, conn):
    H.B.send("PersonalConfig", {"getCustomUnitProperties": CUSTOM_UNITS}, conn)


@on("PersonalConfig", "screenTurnedOff")
def pc_screen_off(dest, args, conn):
    pass  # display-off bookkeeping only; the HMI draws the black screen itself


# ---------------------------------------------------------------- VehSetting
def veh_set(key, value):
    H.B.prop_store("VehSetting")[key] = value
    H.B.mod("VehSetting")[key] = {key: value}  # VehSetting signals are nested like PersonalConfig
    H.B.send("VehSetting", {key: {key: value}})


@on("VehSetting", "setProperties")
def veh_set_props(dest, args, conn):
    for k, v in _props(args).items():
        if k in SEAT_PARTNER and v != "off" and H.B.prop_store("VehSetting").get(SEAT_PARTNER[k]) != "off":
            veh_set(SEAT_PARTNER[k], "off")
        veh_set(k, v)


# ---------------------------------------------------------------- VehicleStatus
@on("VehicleStatus", "getKeySenseSecurityPIN")
def vs_keysense_pin(dest, args, conn):
    H.B.send("VehicleStatus", {"getKeySenseSecurityPIN": {"KeySensePIN": "FFFF"}}, conn)


@on("VehicleStatus", "setSpeedLockOutFeature")
def vs_lockout_feature(dest, args, conn):
    H.B.prop_store("VehicleStatus")["speedLockOutFeature"] = args.get("setting", "on")
    H.B.send("VehicleStatus", {"setSpeedLockOutFeature": {"setting": args.get("setting", "on")}}, conn)


# ---------------------------------------------------------------- AudioSettings
def audio_signals():
    a = AUDIO
    return {"equalizer": {"bass": a["bass"], "mid": a["mid"], "treble": a["treble"]},
            "balanceFade": {"balance": a["balance"], "fade": a["fade"]},
            "loudness": {"loudness": a["loudness"]},
            "speedAdjustedVolume": {"on": a["speedOn"], "variance": a["variance"]},
            "surroundSoundStatus": {"on": a["surround"]}}


def audio_store():
    """Keep the canned get* replies (state.json "_replies") in step with AUDIO."""
    sig = audio_signals()
    H.B.STATE.setdefault("_replies", {}).setdefault("AudioSettings", {}).update(
        getEqualizer=sig["equalizer"], getBalanceFade=sig["balanceFade"], getLoudness=sig["loudness"],
        getSpeedAdjustedVolume=sig["speedAdjustedVolume"], getSurroundSoundStatus=sig["surroundSoundStatus"],
        getSurroundSoundAvailable={"on": True})
    return sig


def audio_publish(changed=("equalizer", "balanceFade", "loudness", "speedAdjustedVolume", "surroundSoundStatus")):
    sig = audio_store()
    for k in changed:
        H.B.mod("AudioSettings")[k] = sig[k]
        H.B.send("AudioSettings", {k: sig[k]})


def _audio_cmd(signal, apply):
    def fn(dest, args, conn):
        apply(args)
        audio_publish((signal,))
        save()
    return fn


for _cmd, _sig, _apply in [
    ("setEqualizer", "equalizer",
     lambda a: AUDIO.update({k: int(a[k]) for k in ("bass", "mid", "treble") if k in a})),
    ("setBalanceFade", "balanceFade",
     lambda a: AUDIO.update({k: int(a[k]) for k in ("balance", "fade") if k in a})),
    ("setLoudness", "loudness", lambda a: AUDIO.update(loudness=a.get("loudness") in (True, "true"))),
    ("setSpeedAdjustedVolume", "speedAdjustedVolume",
     lambda a: AUDIO.update(speedOn=a.get("on") in (True, "true"), variance=int(a.get("variance", 0)))),
    ("setSurroundSoundStatus", "surroundSoundStatus", lambda a: AUDIO.update(surround=a.get("on") in (True, "true"))),
]:
    H._pending.append(("AudioSettings", _cmd, _audio_cmd(_sig, _apply)))


@on("AudioSettings", "setSurroundSoundAvailable")
def audio_surround_avail(dest, args, conn):
    H.B.send("AudioSettings", {"surroundSoundAvailable": {"on": True}}, conn)


# ---------------------------------------------------------------- Clock
def now_payload():
    t = time.localtime(time.time() + CLOCK["offset"])
    return {"year": t.tm_year, "month": t.tm_mon, "day": t.tm_mday,
            "hour": t.tm_hour, "minute": t.tm_min, "second": t.tm_sec, "status": "ok"}


# shortcut: handlers.ticker/getTime read handlers.now_payload by name, so swapping it applies
# the user's clock offset everywhere without touching handlers.py; move the offset there if it grows.
H.now_payload = now_payload


def clock_move_to(target_epoch):
    CLOCK["offset"] = int(target_epoch - time.time())
    H.B.send("Clock", {"time": now_payload()})
    save()


def _shifted(years=0, months=0):
    t = time.localtime(time.time() + CLOCK["offset"])
    m = t.tm_mon - 1 + months
    y, m = t.tm_year + years + m // 12, m % 12 + 1
    d = min(t.tm_mday, calendar.monthrange(y, m)[1])
    return time.mktime((y, m, d, t.tm_hour, t.tm_min, t.tm_sec, 0, 0, -1))


@on("Clock", "setTime")
def clock_set_time(dest, args, conn):
    t = time.localtime(time.time() + CLOCK["offset"])
    clock_move_to(time.mktime((int(args.get("year", t.tm_year)), int(args.get("month", t.tm_mon)),
                               int(args.get("day", t.tm_mday)), int(args.get("hour", t.tm_hour)),
                               int(args.get("minute", t.tm_min)), t.tm_sec, 0, 0, -1)))


@on("Clock", "adjustManualOffset")
def clock_adjust(dest, args, conn):
    clock_move_to(time.time() + CLOCK["offset"] + int(args.get("offset", 0)))


@on("Clock", "adjustMonth")
def clock_adjust_month(dest, args, conn):
    clock_move_to(_shifted(months=int(args.get("month", 0))))


@on("Clock", "adjustYear")
def clock_adjust_year(dest, args, conn):
    clock_move_to(_shifted(years=int(args.get("year", 0))))


@on("Clock", "getOffsetValues")
def clock_offsets(dest, args, conn):
    H.B.send("Clock", {"getOffsetValues": {"timeZoneOffset": 0, "daylightOffset": 0,
                                           "manualOffset": CLOCK["offset"], "timeZone": "EST"}}, conn)


@on("Clock", "setProperties")
def clock_set_props(dest, args, conn):
    for k, v in _props(args).items():
        H.B.set_property("Clock", k, v)
    save()


# ---------------------------------------------------------------- platform (VersionInfo)
def read_versions():
    """version.txt [ifs] header + [packages] name:version:path lines."""
    ifs, pkgs = {}, {}
    try:
        for line in open(VERSION_FILE, encoding="utf-8", errors="replace"):
            line = line.strip()
            if "=" in line and ":" not in line:
                k, v = line.split("=", 1)
                ifs[k.strip()] = v.strip()
            elif line.count(":") >= 2:
                name, ver = line.split(":")[:2]
                pkgs[name] = ver
    except OSError:
        pass
    return ifs, pkgs


def versions():
    ifs, pkgs = read_versions()
    ioc = pkgs.get("V850", "").split()  # "17.41.91 app 17.09.00 bolo"
    return {"app_version": ifs.get("version", "17.43.01"),
            "eq_version": pkgs.get("BaseEQPackage", ""),
            "nav_version": pkgs.get("nav", "").split()[0] if pkgs.get("nav") else "",
            "ioc_app_version": ioc[0] if ioc else "", "ioc_boot_version": ioc[2] if len(ioc) > 2 else "",
            "translation_version": pkgs.get("localization_as3", "")}


@on("platform", "get_all_versions")
def platform_versions(dest, args, conn):
    H.B.send("platform", {"get_all_versions": versions()}, conn)


@on("platform", "get_eq_version")
def platform_eq(dest, args, conn):
    H.B.send("platform", {"get_eq_version": {"eq_version": versions()["eq_version"]}}, conn)


@on("platform", "get_translation_version")
def platform_translation(dest, args, conn):
    H.B.send("platform", {"get_translation_version": {"translation_version": versions()["translation_version"]}}, conn)


@on("platform", "get_partnumber")
def platform_partnumber(dest, args, conn):
    ifs, _ = read_versions()
    # No part number ships in the update; show which software variant this is instead.
    H.B.send("platform", {"get_partnumber": {"partnumber": f"RA4 {ifs.get('vp', 'VP4')} {ifs.get('variant', 'NAFTA')}"}}, conn)


@on("platform", "get_serialnumber")
def platform_serial(dest, args, conn):
    H.B.send("platform", {"get_serialnumber": {"serialnumber": "EMU00000001"}}, conn)


@on("platform", "get_service_flags")
def platform_flags(dest, args, conn):
    H.B.send("platform", {"get_service_flags": {"eng_menu": False}}, conn)


def restore_defaults():
    for k, v in PC_DEFAULTS.items():
        if H.B.prop_store("PersonalConfig").get(k) != v:
            pc_set(k, v)
    for k, v in CLOCK_DEFAULTS.items():
        H.B.set_property("Clock", k, v)
    AUDIO.update(AUDIO_DEFAULTS)
    audio_publish()
    CLOCK["offset"] = 0
    H.B.send("Clock", {"time": now_payload()})
    save()


@on("platform", "clearCustRadioSettings")
def platform_restore(dest, args, conn):
    restore_defaults()


@on("platform", "do_factory_reset")
def platform_factory_reset(dest, args, conn):
    restore_defaults()


@on("platform", "clearPersonalData")
def platform_clear_personal(dest, args, conn):
    pass  # phone book / recents / favourites belong to the phone + nav modules


@on("platform", "calibrate_touchscreen")
def platform_calibrate(dest, args, conn):
    pass


def init(B):
    saved = {}
    if os.path.exists(SAVE_FILE):
        try:
            saved = json.load(open(SAVE_FILE, encoding="utf-8"))
        except ValueError:
            saved = {}
    pc = B.prop_store("PersonalConfig")
    pc.update(copy.deepcopy(PC_DEFAULTS), **saved.get("PersonalConfig", {}))
    B.mod("PersonalConfig").update({k: {k: v} for k, v in pc.items()})

    B.prop_store("VehicleConfig").update(VEHCFG)

    B.prop_store("VehSetting").update(VEH)
    B.mod("VehSetting").update({k: {k: v} for k, v in VEH.items()})

    B.prop_store("VehicleStatus").update(VSTATUS)
    B.mod("VehicleStatus").update({k: {k: v} for k, v in VSTATUS.items()})

    # state.json has these as "true"/"false" strings; Clock.as negates timeFormat24, so a
    # string "false" read as true and showed 24h. Real booleans here.
    clk = B.prop_store("Clock")
    clk.update(CLOCK_DEFAULTS, **saved.get("Clock", {}))
    B.mod("Clock").update({k: {k: v} for k, v in clk.items()})
    CLOCK["offset"] = int(saved.get("clockOffset", 0))

    AUDIO.update(saved.get("AudioSettings", {}))
    audio_store()
