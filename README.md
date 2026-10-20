# Uconnect 8.4AN emulator

The **stock** Uconnect 8.4AN touchscreen software (RA4 17.43.01, MY15 NAFTA — Dodge/Chrysler/Jeep/Ram 2015-2017)
running on a Windows PC, straight out of the official USB update files. No head unit needed.

![Radio](docs/screenshots/radio.png)

## What works

Runs at **1024x768** (the 640x480 HMI scaled 1.6x). Every screen below was tapped through in a scripted
regression tour with **zero script errors** in the HMI log:

| | |
|---|---|
| ![](docs/screenshots/radio.png) **Radio** — AM/FM, station names, presets (store/recall), seek, direct tune | ![](docs/screenshots/siriusxm.png) **SiriusXM** — channels, categories, artist/song, presets, Traffic & Weather |
| ![](docs/screenshots/media.png) **Media** — **plays your real music folder** with tags, progress, seek, skip, repeat | ![](docs/screenshots/media-browse.png) **Media browse** — folders, artists, albums, genres, songs |
| ![](docs/screenshots/phone.png) **Phone** — paired "Pixel 8", favorites, incoming calls ringing with the car's own ringtone | ![](docs/screenshots/phonebook.png) **Phonebook** — 22 contacts, favorites |
| ![](docs/screenshots/climate.png) **Climate** — temp (LO/60-90/HI), fan 0-7, A/C, MAX A/C, recirc, AUTO, defrost, modes | ![](docs/screenshots/controls.png) **Controls** — heated/vented seats, heated wheel |
| ![](docs/screenshots/settings.png) **Settings** — Display, Units, Voice, Clock, Safety & Driving Assistance, Lights… (15 menus) | ![](docs/screenshots/apps.png) **Apps** — app grid, drag icons to the menu bar |
| ![](docs/screenshots/nav.png) **Nav menus** — Where To / View Map / Information / Emergency (no map drawing) | ![](docs/screenshots/themes.png) **Themes** — the car's own theme list (here the SRT set on a Hellcat) |
| ![](docs/screenshots/drive-modes.png) **SRT Drive Modes** — Default/Sport/Track/Custom, Valet, red/black key | ![](docs/screenshots/drive-modes-custom.png) **Custom Mode Set-Up** — power, transmission, paddles, traction, suspension, steering |
| ![](docs/screenshots/launch-control.png) **Launch Control / Race Options** — launch RPM, the car's own dial | ![](docs/screenshots/drive-modes-jeep.png) **Grand Cherokee SRT** — Selec-Track modes (here Snow) |
| ![](docs/screenshots/performance-control.png) **Performance Control** — R/T and Scat Pack: Default/Sport Set-Up | ![](docs/screenshots/language.png) **Languages** — the market's language list, switches live |
| ![](docs/screenshots/perf-home.png) **Performance Pages** — Home (car pictures per model) | ![](docs/screenshots/perf-timers.png) **Timers** — 0-60, 1/8, 1/4 mile, braking; Current/Last/Best |
| ![](docs/screenshots/perf-gauges1.png) **Gauges 1** — coolant, oil temp/pressure, battery, trans temp | ![](docs/screenshots/perf-gauges2.png) **Gauges 2** — Hellcat boost, air/fuel, intercooler, intake air |
| ![](docs/screenshots/perf-gforce.png) **G-Force** — the car leans with lateral g, peaks | ![](docs/screenshots/perf-engine.png) **Engine** — speed, horsepower, torque, boost/oil pressure, gear |
| ![](docs/screenshots/perf-viper.png) **Viper** — its own SRT Performance Pages app (with Options) | |

Also:
- **Boot splash** — the car's own brand splash images, chosen exactly like the firmware's `splash.lua` (brand + SRT/SiriusXM/Beats flags).
- **Themes** — all brand themes (Dodge, Jeep, Chrysler, Ram, SRT, Viper, Fiat, Maserati…); switch from the panel or live in the head unit's own Settings.
- **Sound** — Media plays real files through Windows (play/pause/skip/seek, volume knob, mute); incoming calls ring.
- **Hardware panel** in the browser — volume & tune knobs, faceplate keys, climate knobs, gear shift, theme & splash pickers, restart, raw message injector.
- **CAN signal map** (`can/`) — 261 CAN message IDs / 1,511 signals (byte, bit, mask, PPS object) extracted from the firmware's `canservice`, for 9 vehicle CAN architectures.

### New in this update

- **SRT Drive Modes** — the head unit's own Drive Modes screens (Default/Sport/Track/Custom, Custom Set-Up, Launch
  Control, Shift Light, Valet with PIN, Eco), answered by a fake drive-mode controller (`modules/drivemode.py`).
  Hellcat red/black key with 500 / 700+ hp. Jeep Grand Cherokee SRT with its own screens and the Selec-Track dial
  (Auto/Sport/Track/Snow/Tow) on the panel.
- **Performance Control** — non-SRT R/T and Scat Pack cars get the stock "Dodge/Chrysler Performance Control" app
  (Launch Control, Default/Sport Set-Up).
- **Performance Pages** — the Java apps can't run off the car, so they are redrawn from their own artwork, fonts and
  layout (Home, Timers, Gauges 1/2, G-Force, Engine) inside the head-unit window, over the HMI's own app screen.
  All three stock versions: Challenger/Charger/300 (R/T, SRT, Hellcat), Grand Cherokee SRT, and the Viper's with its
  Options page (home picture, paint colour). A simulated car (launch, cruise, brake, steer) drives them from the panel.
- **Vehicle picker** — 19 cars (Challenger, Charger, 300, Grand Cherokee, Viper, R/T, Scat Pack, non-SRT brands).
  Each sets the car's configuration, theme and boot splash; Settings › Theme lists that car's themes like the car.
- **SiriusXM channel logos** — the firmware's own channel art (`emulator/sdars/channelart`) on the SiriusXM screen.
- **Languages** — Settings › Display › Language now lists the market's languages (North America, Europe, Rest of
  World, Japan, Korea, China…) and switches the whole UI live; market and language are also on the panel.
- **Phone names** — rename the connected phone and the head unit's Bluetooth name from the panel.
- **Real Bluetooth audio** — pair a real phone from Phone › Add Device and play its music through the PC
  (Media › Bluetooth, see *Run it*). Calls and contacts stay simulated.
- **Climate fixes** — climate turns back on, passenger temperature, sync, metric/US ranges.

## What can't work

Anything that is native QNX/ARM code in the real car: the **navigation map engine** (NaviServer), the **voice
recognition** engine and the Java **apps** (xlets). Their menus work; the map surface and speech don't, and of the
Java apps only Performance Pages is redrawn. Real calls over Bluetooth need a hands-free profile Windows doesn't offer.

## Next update

- **Radio & SiriusXM sound** — map FM/AM/SXM presets to internet streams.
- **Bluetooth song info** — read title/artist straight from the phone (AVRCP); Windows doesn't pass it on.
- **Shuffle**, album art from embedded cover images.
- **Splash animations** — decode the `splash_movies/*.bin` boot animations.
- **Voice prompts** — play the stock VR beeps/prompts (`start.wav`, `recog_*.wav`).
- **CAN** — label which signal table belongs to which vehicle architecture; decode the transmit side in the V850 IOC firmware.
- **Uconnect 4C / 8.4 MY18+ (VP4R)** — needs the AES key or a decrypted dump from a unit (see below).

## Run it

**Easy way:** download `UconnectEmulatorSetup.exe` from the [latest release](https://github.com/JEtsKi8271/uconnect-emulator/releases/latest)
and run it. It installs Python (if needed), the emulator, Adobe's AIR runtime and the Python packages into
`%LOCALAPPDATA%\UconnectEmulator` (no admin rights) and adds a **Uconnect 8.4AN** shortcut to the Desktop and Start menu.
Windows SmartScreen may warn because the file isn't signed: *More info › Run anyway*. Source: `installer/`.

**Manual way:**

Needs Windows, Python 3, and the free Adobe AIR 32 SDK (the runtime the car's HMI is built on).

```powershell
git clone https://github.com/JEtsKi8271/uconnect-emulator
cd uconnect-emulator
mkdir tools\airsdk
curl.exe -L -o tools\AdobeAIRSDK.zip https://airdownload.adobe.com/air/win/download/32.0/AdobeAIRSDK.zip
tar -xf tools\AdobeAIRSDK.zip -C tools\airsdk
pip install mutagen pillow
pip install winrt-runtime winrt-Windows.Foundation winrt-Windows.Foundation.Collections winrt-Windows.Media.Audio winrt-Windows.Devices.Enumeration winrt-Windows.Devices.Bluetooth winrt-Windows.Media.Control
emulator\run.bat
```

**Bluetooth audio (optional, needs a Bluetooth adapter):** Phone > Settings > Paired Phones > Add Device makes the PC
discoverable; pick the PC on your phone, confirm the code on both, and the phone plays through the PC as the car's
Bluetooth audio source (Media > Bluetooth, with play/pause/skip). Calls and contacts stay simulated.
iPhones only list audio devices, not PCs: run `emulator\bt_car_audio.ps1` once as administrator so the PC announces
itself as car audio (`-Undo` reverts it). Windows broadcasts the computer name; `emulator\bt_name.ps1 -Name Uconnect`
(as administrator) makes the phone see "Uconnect" instead.

The boot splash shows, then a 1024x768 head-unit window opens (mouse = touch) and the hardware panel opens at http://127.0.0.1:4401/.
**Sound:** your music folder (`~/Music`, or `"musicDir"` in `emulator/config.json`) is the USB stick: Media plays
the real files (mp3/m4a/wma/wav/flac) with their tags, following play/pause/skip/seek, the volume knob and mute.
Incoming calls ring with the car's own ringtone. Radio and SiriusXM stay silent.

Pick the car, theme, splash, market/language and phone names in the panel (http://127.0.0.1:4401/); they're saved in
`emulator/config.json`. Other vehicle equipment is in `emulator/state.json` (`VehicleConfig`).

## How we got here

1. **Unpacking the update.** The 17.43.01 USB update (`swdl.iso`) contains `installer.iso`, `primary.iso` and
   `secondary.iso` — plain, unencrypted ISO9660 images of the head unit's QNX filesystems. Unlike newer units, the
   whole user interface ships in the clear: `primary.iso` → `usr/share/MMC_IFS_EXTENSION/share/hmi_rov` is a complete
   **Adobe AIR 2.5 app** (`main.swf`, `MainSupplement.swf` and ~150 per-screen SWFs, plus skins/themes for every brand).
2. **Running it.** Adobe's AIR 32 SDK still runs AIR 2.5 apps. With a small app descriptor (`emulator/hmi/emulator-app.xml`)
   `adl.exe` launches the stock HMI unmodified (first at 800x480, now 1024x768). It boots… and sits at a black screen waiting for the car.
3. **Reverse-engineering the protocol.** Decompiling the SWFs with [JPEXS FFDec](https://github.com/jindrapetrik/jpexs-decompiler)
   (sources in `decomp/`) showed the HMI talks to the car's native services over one TCP socket
   (`ModuleLink.xml` → `127.0.0.1:4400`) using NUL-terminated JSON:
   `{"Length":00085,"Type":"Command","Dest":"Tuner","packet":{...}}` out, `{"Tuner":{"frequency":...}}` back.
   Roughly 50 modules (`VehicleConfig`, `Audio`, `Tuner`, `Media`, `Hvac`, `Phone`, `SXM`, `Navigation`, persistency…)
   use `Subscribe` / `Command` / signal messages. `emulator/schema.json` lists every field each module reads,
   extracted from the AS3.
4. **Faking the car.** `emulator/backend.py` is a Python server that plays all those services: a generic module state
   machine (subscriptions, get/set properties, persistency) driven by `state.json`, plus per-feature behaviour in
   `handlers.py` and `emulator/modules/` (tuner, media library, HVAC zones, phone, SiriusXM, settings, nav).
   It also writes the binary `hmiVars` boot file (brand, theme, region, language) the car normally provides.
5. **Fixing the boot chain.** The HMI only shows its UI after `VehicleConfig` → `AudioManager` → `AppManager` report
   ready, and the disclaimer is accepted. Each AS3 runtime error (`Error #1069`, `#1010`, `#2007` …) pointed at a
   message with the wrong shape; fixing them one by one got every screen up. Notable gotchas:
   AIR's XMLSocket truncates frames sent in one burst (fixed with a per-connection paced writer queue);
   persistency reads must be `{"value":…}` objects; tuner presets are 0-based, media tracks 1-based.
6. **Parallel agents.** With the core working, a dev harness (`emulator/dev/uc.py`) runs isolated emulator copies
   side by side (own port, own AIR app id, screenshots, click injection) so several Claude Code agents built Phone,
   Settings, SiriusXM and Nav/Apps at the same time, each verifying by screenshot.
7. **Polish.** Real audio via Windows MCI, the stock boot splash, theme switching, 1024x768, and a nav start-up fix:
   the emulator now answers the nav engine's version query and its own persistence format, so nav reaches "ready"
   in ~8 s instead of a 20 s fallback (which had made incoming calls crash `MapController` right after boot).
8. **CAN.** The QNX boot image (`ifs-cmc.bin`, LZO-compressed) was unpacked with a small pure-Python unpacker, its Lua
   services decompiled with unluac, and the signal tables in `canservice` decoded and checked against `ChimeControl.lua`.

## Contributors

- [@JEtsKi8271](https://github.com/JEtsKi8271)
- [@exycalll](https://github.com/exycalll)
- Claude (Anthropic)

## Firmware downloads

The original update images are attached to the [v1.0 release](https://github.com/JEtsKi8271/uconnect-emulator/releases/tag/v1.0):

| File | SHA-256 |
|---|---|
| `swdl.iso` (full USB update) | `36E85189BB83EEE8CE6A8E1DC7E9EEFE917BB058CC5CD45EF65556E24827CD7C` |
| `installer.iso` | `C854220482E0F559142B7018A355085986443BBFB64DD0822B722C434314B512` |
| `primary.iso` | `1B60F7AAC9AB14B91176EE30D08603410B971A60A9E01094527A0B6113200645` |
| `secondary.iso` | `5335D54C2813EC11ACFB198534C4A021B7EF81B568C656B2E021103310CC8B09` |

## What about newer Uconnect (4C / 8.4 MY18+)?

The MY18-21 "VP4R" updates (e.g. `USA-ASO-8.4-QR-40.1.0`) are different: every package is AES-encrypted
(`encrypted_*.tar.gz`, per-file IVs in `ss_pasa_usb.metadata`) and the key is not in the update — it lives in the head
unit. Without a key or a decrypted dump from a unit, there's no HMI to run.

## Layout

- `emulator/` — the emulator (see `emulator/README.md`): `backend.py`, `handlers.py`, `modules/`, `state.json`, `hmi/` (stock HMI), `panel.html`, `dev/`
- `decomp/` — decompiled ActionScript of the HMI
- `can/` — extracted CAN signal tables (`can_signals.csv`, `can_ids.csv`) and the tools that produced them
- `docs/screenshots/`

Uconnect, Dodge, SiriusXM etc. are trademarks of their owners; the HMI and firmware are © Stellantis / Harman.
This is an unofficial research project.
