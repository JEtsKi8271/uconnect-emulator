# Uconnect 8.4AN emulator (RA4 17.43.01, MY15 NAFTA)

Runs the **stock** Uconnect 8.4AN touchscreen software from the `swdl` update ISOs on Windows.
The HMI is an Adobe AIR app (`hmi/`, copied unmodified from `primary.iso` →
`usr/share/MMC_IFS_EXTENSION/share/hmi_rov`). In the car it talks to native QNX services over a
local socket; here `backend.py` plays those services (radio, media, climate, phone, settings …).

## Run
Double-click `run.bat` (needs Python 3 on PATH). It starts the backend, opens the hardware panel
in your browser (http://127.0.0.1:4401/) and opens the head unit window. Touch = mouse.

Hardware panel: volume / tune knobs, faceplate buttons, climate knobs, shift to R (backup camera),
and a box for sending raw backend frames. Keyboard on the panel page: `+`/`-` volume, `M` mute,
arrows tune, Enter, Backspace = back.

## Configure
`config.json` (applied at next start, written into `hmi/hmiVars` like the car's boot file):
`theme` (e.g. `Dodge/006_Dodge.swf`, `Jeep/056_Jeep.swf`, `Default/001_Uconnect.swf`; see
`hmi/skins/default/themes.xml`), `brandId`, `destinationCode`, `languageId`, `lastScreen`, `navActivated`.
Vehicle equipment flags (nav, cameras, heated seats …) are the `VehicleConfig` entries in `state.json`.

## What can't run
Anything that is native QNX/ARM code in the car: the navigation map engine (NaviServer), the
voice-recognition engine, and the Java "Apps" (xlets). Their menus are emulated; the map surface,
speech and Java apps are not.

## Layout
- `backend.py` — socket server + generic module state machine; `handlers.py` + `modules/*.py` — per-feature behaviour.
- `state.json` — default module state; `config.json` — boot config; `persistency.json` — what the HMI saved.
- `schema.json` — message fields each HMI module reads (extracted from the decompiled AS3).
- `dev/` — developer harness for running isolated instances (`dev/uc.py`, see `dev/AGENTS.md`).
- Tools live in `../tools` (Adobe AIR 32 SDK, JPEXS FFDec decompiler); decompiled sources in `../decomp`.
