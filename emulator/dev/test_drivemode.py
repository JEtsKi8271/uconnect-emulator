"""Self-check of the Drive Mode car logic without an HMI:  python dev/test_drivemode.py"""
import json, os, sys, tempfile, types
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
H = types.ModuleType("handlers")
H.on = lambda m, c: (lambda f: f)
H.PANEL_ACTIONS, H.EMIT_HOOKS, H.hard_key = {}, [], lambda k: None
H.B = types.SimpleNamespace(send=lambda *a, **k: None, log=print)
H.json, H.CONFIG_FILE = json, os.path.join(tempfile.mkdtemp(), "config.json")
json.dump({"vehicle": {"model": "challenger_hellcat"}}, open(H.CONFIG_FILE, "w"))
H.update_config = lambda **kv: None
sys.modules["handlers"] = H
import modules.drivemode as d

d.set_prop("globalDriveModeStatus", "track")
assert d.props()["enginePowerMode"] == "red" and d.props()["transmissionMode"] == "track"
d.set_prop("activeDampingStatus", {"type": "custom", "value": "track"})
assert d.CAR["tables"]["custom"]["activeDampingDriveMode"] == "track"
d.set_prop("launchButtonStatus", "on")
assert d.props()["launchButtonStatus"] == "on" and d.props()["driveModeIndicator3"] == "true"
d.set_prop("launchButtonStatus", "on")
assert d.props()["launchButtonStatus"] == "off"
d.set_prop("globalDriveModeStatus", "valet")
assert d.props()["enginePowerMode"] == "valet"
d.set_prop("globalDriveModeStatus", "valet")  # correct PIN sends valet again -> leaves valet
assert d.props()["globalDriveModeStatus"] == "default"
d.on_emit({"ecoModeActiveRequest": {"value": "true"}})
assert d.props()["ecoModeActive"] == "true"
assert d.props()["launchRPMSetPoint"] == "1500"  # automatic default
print("ok")
