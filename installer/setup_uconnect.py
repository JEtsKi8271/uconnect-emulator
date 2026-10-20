"""Uconnect 8.4AN emulator installer (built into UconnectEmulatorSetup.exe with PyInstaller, see build.bat).

Installs into %LOCALAPPDATA%\\UconnectEmulator (no admin needed):
  1. Python 3.12 (python.org installer, per-user, only if no Python 3.10+ is found)
  2. the emulator (this release's source from GitHub)
  3. Adobe AIR SDK 32 runtime (from Adobe; only the parts adl.exe needs are kept)
  4. Python packages: mutagen, pillow, winrt-* (Bluetooth audio)
  5. Desktop + Start menu shortcuts "Uconnect 8.4AN"

    UconnectEmulatorSetup.exe [--dir PATH] [--no-shortcuts]
"""
import argparse, os, shutil, subprocess, sys, tempfile, time, urllib.request, zipfile

VERSION = "v1.1"
REPO_ZIP = f"https://github.com/JEtsKi8271/uconnect-emulator/archive/refs/tags/{VERSION}.zip"
AIR_ZIP = "https://airdownload.adobe.com/air/win/download/32.0/AdobeAIRSDK.zip"
PY_EXE = "https://www.python.org/ftp/python/3.12.10/python-3.12.10-amd64.exe"
PIP = ["mutagen", "pillow", "winrt-runtime", "winrt-Windows.Foundation", "winrt-Windows.Foundation.Collections",
       "winrt-Windows.Media.Audio", "winrt-Windows.Devices.Enumeration", "winrt-Windows.Devices.Bluetooth",
       "winrt-Windows.Media.Control"]
AIR_KEEP = ("bin/adl.exe", "runtimes/air/win/")  # adl + the AIR runtime it loads; the rest is SDK tooling


def say(msg):
    print(msg, flush=True)


def download(url, dest):
    say(f"  downloading {url.rsplit('/', 1)[-1]} ...")
    req = urllib.request.Request(url, headers={"User-Agent": "UconnectEmulatorSetup"})
    with urllib.request.urlopen(req, timeout=60) as r, open(dest, "wb") as f:
        total, done, last = int(r.headers.get("Content-Length") or 0), 0, 0
        while chunk := r.read(1 << 20):
            f.write(chunk)
            done += len(chunk)
            if total and time.time() - last > 1:
                say(f"    {done * 100 // total:3d}%  ({done >> 20} / {total >> 20} MB)")
                last = time.time()
    return dest


def find_python():
    """A 64-bit Python 3.10-3.13 with tkinter (the boot splash uses it): PATH first, then the py launcher."""
    probe = ("import sys, struct, tkinter; "
             "print((3, 10) <= sys.version_info < (3, 14) and struct.calcsize('P') == 8, sys.executable)")
    for cmd in (["python"], ["py", "-3.13"], ["py", "-3.12"], ["py", "-3.11"], ["py", "-3.10"]):
        try:
            out = subprocess.run(cmd + ["-c", probe], capture_output=True, text=True, timeout=30)
        except (OSError, subprocess.TimeoutExpired):
            continue
        ok, _, exe = out.stdout.strip().partition(" ")
        if out.returncode == 0 and ok == "True" and "WindowsApps" not in exe:  # skip the Store stub
            return exe
    return None


def install_python(tmp):
    say("[1/5] Python 3.10+ not found: installing Python 3.12 (per-user) ...")
    exe = download(PY_EXE, os.path.join(tmp, "python-setup.exe"))
    subprocess.run([exe, "/quiet", "InstallAllUsers=0", "PrependPath=1", "Include_tcltk=1", "Include_pip=1",
                    "Include_launcher=1", "Include_test=0"], check=True)
    py = os.path.join(os.environ["LOCALAPPDATA"], "Programs", "Python", "Python312", "python.exe")
    if not os.path.exists(py):
        sys.exit("Python install failed; install Python 3.12 from python.org and run this again.")
    return py


def install_emulator(tmp, target):
    say(f"[2/5] Downloading the emulator ({VERSION}) ...")
    z = download(REPO_ZIP, os.path.join(tmp, "emulator.zip"))
    with zipfile.ZipFile(z) as zf:
        root = zf.namelist()[0].split("/")[0]
        keep = None
        cfg = os.path.join(target, "emulator", "config.json")
        if os.path.exists(cfg):  # updating: keep the user's car/theme/language settings
            keep = open(cfg, "rb").read()
        for m in zf.infolist():
            rel = m.filename[len(root) + 1:]
            if not rel or rel.startswith("decomp/"):  # decompiled sources: not needed to run
                continue
            dest = os.path.join(target, rel)
            if m.is_dir():
                os.makedirs(dest, exist_ok=True)
            else:
                os.makedirs(os.path.dirname(dest), exist_ok=True)
                with zf.open(m) as src, open(dest, "wb") as out:
                    shutil.copyfileobj(src, out)
        if keep:
            open(cfg, "wb").write(keep)


def install_air(tmp, target):
    adl = os.path.join(target, "tools", "airsdk", "bin", "adl.exe")
    if os.path.exists(adl):
        say("[3/5] Adobe AIR runtime already there.")
        return
    say("[3/5] Downloading the Adobe AIR SDK (430 MB, from Adobe) ...")
    z = download(AIR_ZIP, os.path.join(tmp, "air.zip"))
    say("  extracting adl.exe and the AIR runtime ...")
    with zipfile.ZipFile(z) as zf:
        for m in zf.infolist():
            if m.filename.startswith(AIR_KEEP) and not m.is_dir():
                dest = os.path.join(target, "tools", "airsdk", m.filename)
                os.makedirs(os.path.dirname(dest), exist_ok=True)
                with zf.open(m) as src, open(dest, "wb") as out:
                    shutil.copyfileobj(src, out)


def install_packages(py):
    say("[4/5] Installing Python packages ...")
    subprocess.run([py, "-m", "pip", "install", "--disable-pip-version-check", "-q"] + PIP, check=True)


def point_run_bat(py, target):
    """run.bat starts "python": make it the Python the packages went into."""
    bat = os.path.join(target, "emulator", "run.bat")
    text = open(bat, encoding="utf-8").read().replace('start "Uconnect backend" /min python ',
                                                      f'start "Uconnect backend" /min "{py}" ')
    open(bat, "w", encoding="utf-8").write(text)


def shortcuts(py, target):
    say("[5/5] Creating shortcuts ...")
    bat = os.path.join(target, "emulator", "run.bat")
    icon = os.path.join(target, "emulator", "hmi", "icon.ico")
    for folder in (os.path.join(os.environ["USERPROFILE"], "Desktop"),
                   os.path.join(os.environ["APPDATA"], "Microsoft", "Windows", "Start Menu", "Programs")):
        lnk = os.path.join(folder, "Uconnect 8.4AN.lnk")
        ps = (f"$s=(New-Object -ComObject WScript.Shell).CreateShortcut('{lnk}');"
              f"$s.TargetPath='{bat}';$s.WorkingDirectory='{os.path.dirname(bat)}';"
              f"$s.WindowStyle=7;$s.Description='Uconnect 8.4AN emulator';"
              + (f"$s.IconLocation='{icon}';" if os.path.exists(icon) else "") + "$s.Save()")
        subprocess.run(["powershell", "-NoProfile", "-Command", ps], check=False, capture_output=True)


def main():
    ap = argparse.ArgumentParser(description="Install the Uconnect 8.4AN emulator")
    ap.add_argument("--dir", default=os.path.join(os.environ.get("LOCALAPPDATA", "."), "UconnectEmulator"))
    ap.add_argument("--no-shortcuts", action="store_true")
    a = ap.parse_args()
    say(f"Uconnect 8.4AN emulator {VERSION} setup\nInstalling into {a.dir}\n")
    os.makedirs(a.dir, exist_ok=True)
    tmp = tempfile.mkdtemp(prefix="uconnect-setup-")
    try:
        py = find_python()
        if py:
            say(f"[1/5] Using Python: {py}")
        else:
            py = install_python(tmp)
        install_emulator(tmp, a.dir)
        install_air(tmp, a.dir)
        install_packages(py)
        point_run_bat(py, a.dir)
        if not a.no_shortcuts:
            shortcuts(py, a.dir)
    finally:
        shutil.rmtree(tmp, ignore_errors=True)
    say("\nDone. Start it with the \"Uconnect 8.4AN\" shortcut (or emulator\\run.bat).")


if __name__ == "__main__":
    try:
        main()
    except Exception as e:  # keep the window open so the user can read what went wrong
        print(f"\nSetup failed: {e!r}")
    try:
        if sys.stdin and sys.stdin.isatty():
            input("\nPress Enter to close.")
    except (EOFError, OSError):
        pass
