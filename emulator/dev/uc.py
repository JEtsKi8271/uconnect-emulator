"""Dev harness: run isolated emulator instances side by side.

    python dev/uc.py NAME start PORT     # fresh backend + HMI window on PORT (panel on PORT+1)
    python dev/uc.py NAME restart        # restart backend + HMI (keeps the port)
    python dev/uc.py NAME stop
    python dev/uc.py NAME snap OUT.png   # screenshot this instance's window
    python dev/uc.py NAME click X Y [HOLD_MS]   # tap at client coords (screenshot y - 30)
    python dev/uc.py NAME act ACTION VALUE      # panel action: key/volume/tune/gear/temp/inject
    python dev/uc.py NAME errors         # AS3 errors + malformed frames from the HMI trace
    python dev/uc.py NAME unhandled      # commands the backend did not answer

Instance files live in dev/NAME/: hmi/ (copy with its own ModuleLink.xml port), backend.log,
adl.log, persistency.json, config.json. Only this instance's processes are ever killed.
"""
import json, os, shutil, subprocess, sys, time, urllib.request

EMU = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ADL = os.path.join(EMU, "..", "tools", "airsdk", "bin", "adl.exe")


def inst(name):
    return os.path.join(EMU, "dev", name)


def meta(name):
    p = os.path.join(inst(name), "instance.json")
    return json.load(open(p)) if os.path.exists(p) else {}


def save_meta(name, m):
    json.dump(m, open(os.path.join(inst(name), "instance.json"), "w"))


def kill(pid):
    if pid:
        subprocess.run(["taskkill", "/F", "/T", "/PID", str(pid)], capture_output=True)


def stop(name):
    m = meta(name)
    kill(m.get("adl"))
    kill(m.get("backend"))
    m.pop("adl", None), m.pop("backend", None)
    if m:
        save_meta(name, m)


def start(name, port):
    d = inst(name)
    stop(name) if os.path.isdir(d) else None
    os.makedirs(d, exist_ok=True)
    hmi = os.path.join(d, "hmi")
    if not os.path.isdir(hmi):
        shutil.copytree(os.path.join(EMU, "hmi"), hmi, ignore=shutil.ignore_patterns("hmiVars"))
    with open(os.path.join(hmi, "ModuleLink.xml"), "w") as f:
        f.write(f'<moduleLink name="HMI">\n  <span host="127.0.0.1" port="{port}" />\n'
                f'  <hb host="127.0.0.1" port="{port}" />\n</moduleLink>\n')
    # AIR runs one copy per app id; a shared id would hand this launch to another window.
    app = open(os.path.join(EMU, "hmi", "emulator-app.xml"), encoding="utf-8").read()
    app = app.replace("<id>uconnect.hmi.emulator</id>", f"<id>uconnect.hmi.emulator.{name}</id>")
    app = app.replace("<title>Uconnect 8.4AN (RA4 17.43.01)</title>", f"<title>Uconnect dev: {name}</title>")
    open(os.path.join(hmi, "emulator-app.xml"), "w", encoding="utf-8").write(app)
    if not os.path.exists(os.path.join(d, "config.json")):
        shutil.copy(os.path.join(EMU, "config.json"), d)
    env = dict(os.environ, UC_INSTANCE_DIR=d, UC_PORT=str(port))
    flags = subprocess.CREATE_NO_WINDOW
    be = subprocess.Popen([sys.executable, os.path.join(EMU, "backend.py")], cwd=EMU, env=env,
                          stdout=open(os.path.join(d, "backend.out"), "w"), stderr=subprocess.STDOUT,
                          creationflags=flags)
    time.sleep(1.0)
    if be.poll() is not None:
        sys.exit("backend died:\n" + open(os.path.join(d, "backend.out")).read())
    adl = subprocess.Popen([ADL, "-profile", "extendedDesktop", os.path.join(hmi, "emulator-app.xml"), hmi],
                           stdout=open(os.path.join(d, "adl.log"), "w"), stderr=subprocess.STDOUT)
    save_meta(name, {"port": port, "backend": be.pid, "adl": adl.pid})
    print(f"{name}: backend pid {be.pid} port {port}, panel http://127.0.0.1:{port + 1}/, adl pid {adl.pid}")


def win(name, *args):
    pid = meta(name)["adl"]
    r = subprocess.run(["powershell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-File",
                        os.path.join(EMU, "dev", "win.ps1"), "-procId", str(pid), *args],
                       capture_output=True, text=True)
    print((r.stdout + r.stderr).strip())


def act(name, action, value):
    port = meta(name)["port"] + 1
    req = urllib.request.Request(f"http://127.0.0.1:{port}/act", method="POST",
                                 data=json.dumps({"action": action, "value": value}).encode())
    print(urllib.request.urlopen(req).status)


def errors(name):
    lines = open(os.path.join(inst(name), "adl.log"), encoding="utf-8", errors="replace").read().splitlines()
    for i, l in enumerate(lines):
        if "Error #" in l or "Malformed" in l:
            print("\n".join(lines[i:i + 3])[:600])
            print("--")


def unhandled(name):
    seen = set()
    for l in open(os.path.join(inst(name), "backend.log"), encoding="utf-8", errors="replace"):
        if " ?? " in l or " !! " in l:
            k = l[9:].strip()[:220]
            if k not in seen:
                seen.add(k)
                print(k)


if __name__ == "__main__":
    name, cmd, *rest = sys.argv[1:]
    if cmd == "start":
        start(name, int(rest[0]))
    elif cmd == "restart":
        start(name, meta(name)["port"])
    elif cmd == "stop":
        stop(name)
    elif cmd == "snap":
        win(name, "snap", os.path.abspath(rest[0]))
    elif cmd == "click":
        win(name, "click", rest[0], rest[1], *(["-hold", rest[2]] if len(rest) > 2 else []))
    elif cmd == "act":
        act(name, rest[0], rest[1])
    elif cmd == "errors":
        errors(name)
    elif cmd == "unhandled":
        unhandled(name)
    else:
        sys.exit(__doc__)
