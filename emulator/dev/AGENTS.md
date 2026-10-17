# Working on the Uconnect 8.4AN emulator

Root: `C:\Users\JEtsKi\Downloads\UCONNECT_8.4AN_RA4_17.43.01_MY15_NAFTA` (call it ROOT).

## What this is
The stock Uconnect 8.4AN HMI (Adobe AIR / AS3 SWFs from the firmware update, in `emulator/hmi/`)
runs unmodified in Adobe AIR (`tools/airsdk/bin/adl.exe`). It talks to a fake vehicle backend
(`emulator/backend.py`, Python) over TCP: NUL-terminated JSON.

- HMI -> backend: `{"Length":00085, "Type":"Command"|"Subscribe"|"subscribeNameHasOwnerNotification"|"EmitSignal", "Dest":"<Module>", "packet":{<command>:{args}}}` or `"Signal"/"Signals"` for Subscribe.
- backend -> HMI: always `{"<Module>": {<key>: <value>}}`. `<key>` is a signal name, or the command name for a reply (`{"Media":{"getDevices":{...}}}`).
- `subscribeNameHasOwnerNotification` is answered `{"<Module>":{"dBusServiceAvailable":"true"}}` (generic).
- Generic backend behaviour (backend.py `handle_command`): Subscribe re-emits `B.mod(Module)[signal]` if present;
  `getProperties`/`getAllProperties` answer from `B.props_of(Module)` (raw values);
  `setProperties` stores + emits via `B.set_property` (nested `{k:{k:v}}` for modules in `B.NESTED`, raw otherwise);
  `read`/`write` on any `*Persistency`/`Persistency`/`*PersistenceManager` is a key-value store;
  canned replies live in `B.STATE["_replies"][Module][command]`.
  Anything else is logged as `?? unhandled Module.command {...}` in the instance's backend.log.

## Where the truth is
- Decompiled HMI code: `ROOT/decomp/MainSupplement/scripts/` (module classes in `com/nfuzion/moduleLink/*.as`,
  `com/harman/moduleLink/*.as`; enums/events in `*moduleLinkAPI/`), `ROOT/decomp/main/scripts/`.
  Each module's `<x>MessageHandler(e:ConnectionEvent)` shows exactly which fields it reads; its `send*` helpers show
  the command shapes. `dbusIdentifier` = the Dest/Module name.
- `emulator/schema.json`: per module class, the message field paths its handlers read (auto-extracted; a hint, not gospel).
- Screen SWFs: `emulator/hmi/skins/default/swf/<Screen>.swf`. Decompile one when you need screen logic:
  `java -jar ROOT/tools/ffdec/ffdec-cli.jar -export script ROOT/decomp/<Screen> ROOT/emulator/hmi/skins/default/swf/<Screen>.swf`
  (output: `decomp/<Screen>/scripts/screens/NA_EU/RES_640x480/<Screen>.as`). Reuse an existing decomp dir if present.
- Look at `emulator/handlers.py` for worked examples (tuner, HVAC, media, clock, anti-theft).

## Lessons already paid for
- Read the handler before guessing shapes: signal vs reply shapes often differ (e.g. AntiTheft signal `{"ignState":{"value":"on"}}` but getProperties raw `"on"`).
- Booleans vs strings matter (`"true"` vs `true`); copy whatever the AS3 compares against.
- Positions/indices: check 0- vs 1-based in the AS3 (tuner presets are 0-based, media track numbers 1-based).
- A screen often ignores data that arrives before it loaded; it re-reads on its own events. If a widget stays stale, find the event it listens for.
- Runtime errors appear as `TypeError/ReferenceError ... Error #10xx` in adl.log with the AS3 function name: that's your bug pointer.
- Region is NAFTA (no RDS widgets etc.). Vehicle: Dodge, platform "LA", brandId 2, theme Dodge/006_Dodge.swf.

## How to write code
- Your feature goes in ONE file you own: `emulator/modules/<yours>.py`. Pattern:
  ```python
  import handlers as H
  from handlers import on

  @on("PhoneBook", "getItemsCount")
  def phonebook_count(dest, args, conn):
      H.B.send("PhoneBook", {"getItemsCount": {...}}, conn)   # conn = reply to requester; omit to broadcast

  def init(B):            # optional: seed defaults at backend start (no sends here)
      B.mod("BluetoothGAP")["bluetoothStatus"] = {...}         # signal values (emitted on Subscribe)
      B.prop_store("BluetoothGAP")["x"] = ...                  # get(All)Properties values
      B.STATE.setdefault("_replies", {}).setdefault("X", {})["getY"] = {...}
  ```
  `H.B` is the backend module: `send(module, payload, conn=None)`, `mod(name)`, `props_of`, `prop_store`, `set_property`, `NESTED`, `STATE`, `log`.
  Periodic work: start your own daemon thread in `init` (sleep loop), don't touch `handlers.ticker`.
- Do NOT edit `backend.py`, `state.json`, `panel.html` or other people's module files. If you truly need a backend.py
  change, describe it in your final report instead. `handlers.py`: only if your brief says so, only your section.
- Match the existing code style: plain functions, short why-comments, no frameworks.

## How to test (your own isolated instance)
`cd ROOT/emulator` then `python dev/uc.py NAME start PORT` (NAME/PORT from your brief). This copies the HMI to
`dev/NAME/`, starts a backend + its own AIR window titled "Uconnect dev: NAME". Boot takes ~15-20 s.
- `python dev/uc.py NAME snap <abs path>.png` then Read the PNG to see the screen (window is 1040x807 incl. ~31px title bar;
  screen is 1024x768 = the 640x480 HMI stage scaled 1.6x).
- `python dev/uc.py NAME click X Y [HOLD_MS]` taps at CLIENT coords = screenshot coords with x - 8, y - 31.
  Stage coords from the AS3 (640x480) x 1.6 = client coords.
  Taskbar (client y=680): Radio 117, Media 248, Controls 381, Apps 512, Climate 645, Nav 779, Phone 910.
- `python dev/uc.py NAME act key settings` (hard keys: radio player nav phone more settings screenOff enter back browse audioOnOff),
  `act volume 1`, `act tune -1`, `act inject '{"Module":{...}}'` to push any frame.
- `python dev/uc.py NAME errors` / `unhandled`; full traces in `dev/NAME/adl.log` and `dev/NAME/backend.log`.
- `python dev/uc.py NAME restart` after code changes (backend reloads your module). `stop` when done.
- NEVER `taskkill /IM adl.exe` or kill python by name: the user is driving their own emulator window on port 4400.
  Only use dev/uc.py with your own NAME.
- Don't burn time on cosmetics; aim for: every screen in your area opens, shows plausible data, buttons do the
  thing, zero new AS3 errors.

## Final report (keep it short)
What works (screens/actions verified by screenshot), files changed, anything you could not make work and why,
and any backend.py change you need.
