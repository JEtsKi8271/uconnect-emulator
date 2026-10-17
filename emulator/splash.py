"""Boot splash, as the car's QNX `splash` app shows it before the HMI is up.

    python splash.py IMAGE.png PANEL_PORT   # borderless window over the HMI until /status says hmiReady
    python splash.py --test

pick() is cmc/splash.lua getAssetName(): brand byte + splash-flags byte from FRAM
(bit0 SRT, bit1 SiriusXM, bits3-7 type: 1 Beats, 2 Mopar, 3 Shaker, 4 Anniversary).
"""
import json, os, sys, time, urllib.request

HERE = os.path.dirname(os.path.abspath(__file__))
SPLASH_DIR = os.path.join(HERE, "splash")
HMI_TITLE = "Uconnect 8.4AN (RA4 17.43.01)"
SCREEN = (1024, 768)  # head-unit screen size until the HMI window exists
BRAND_FILES = {1: "chrysler", 2: "dodge", 3: "Jeep", 8: "alfa-romeo", 9: "fiat", 10: "lancia",
               11: "Maserati", 12: "RAM"}  # others (Mercedes, Mitsubishi, VW, Freightliner) -> uconnect
TYPES = {1: "beats", 4: "anniversary"}  # Mopar/Shaker use the plain brand image


def pick(brand_id, flags, available):
    """Splash file name for a brand/flags pair; falls back to the plain brand image like assetTable."""
    base = "SRT" if flags & 1 else BRAND_FILES.get(brand_id, "uconnect")
    sxm, kind = flags & 2, TYPES.get((flags & 0xF8) >> 3)
    if sxm and kind == "beats":
        tries = [f"{base}-siriusxm-and-beats"]
    elif kind:
        tries = [f"{base}-{kind}"]
    elif sxm:
        tries = [f"{base}-siriusxm"]
    else:
        tries = []
    for name in tries + [base]:
        if name + ".png" in available:
            return name + ".png"
    return "uconnect.png"


def _test():
    have = set(os.listdir(SPLASH_DIR))
    beats, anniv = 1 << 3, 4 << 3
    # expectations copied from splash.lua assetTable
    assert pick(2, 0, have) == "dodge.png"
    assert pick(2, 2, have) == "dodge-siriusxm.png"
    assert pick(2, 2 | beats, have) == "dodge.png"
    assert pick(3, 2 | beats, have) == "Jeep-siriusxm-and-beats.png"
    assert pick(12, beats, have) == "RAM-beats.png"
    assert pick(2, 1 | 2, have) == "SRT-siriusxm.png"
    assert pick(1, 2 | anniv, have) == "chrysler-anniversary.png"
    assert pick(10, 2, have) == "lancia.png"
    assert pick(5, 0, have) == "uconnect.png"
    print("splash pick ok")


def hmi_client_rect():
    """Screen rect of the HMI window's client area, or None until AIR has opened it."""
    import ctypes
    from ctypes import wintypes
    u = ctypes.windll.user32
    hwnd = u.FindWindowW(None, HMI_TITLE)
    if not hwnd or not u.IsWindowVisible(hwnd):
        return None
    r, pt = wintypes.RECT(), wintypes.POINT(0, 0)
    u.GetClientRect(hwnd, ctypes.byref(r))
    u.ClientToScreen(hwnd, ctypes.byref(pt))
    return pt.x, pt.y, r.right, r.bottom


def hmi_ready(port):
    try:
        with urllib.request.urlopen(f"http://127.0.0.1:{port}/status", timeout=1) as r:
            return json.load(r).get("hmiReady")
    except OSError:
        return False


def show(image, port):
    import ctypes, tkinter as tk
    try:
        ctypes.windll.shcore.SetProcessDpiAwareness(2)  # same pixel space as the AIR window rect
    except (AttributeError, OSError):
        pass
    from PIL import Image, ImageTk
    root = tk.Tk()
    root.overrideredirect(True)
    root.attributes("-topmost", True)
    root.configure(bg="black")
    src = Image.open(image)
    label = tk.Label(root, bg="black", bd=0)
    label.place(relx=0.5, rely=0.5, anchor="center")
    size = [None]

    def fit(w, h):
        # Same "show all" scaling the HMI stage gets: 640x480 art scaled to the screen height/width.
        if size[0] != (w, h):
            size[0] = (w, h)
            s = min(w / src.width, h / src.height)
            label.img = ImageTk.PhotoImage(src.resize((round(src.width * s), round(src.height * s)), Image.LANCZOS))
            label.configure(image=label.img)

    sw, sh = root.winfo_screenwidth(), root.winfo_screenheight()
    root.geometry(f"{SCREEN[0]}x{SCREEN[1]}+{(sw - SCREEN[0]) // 2}+{(sh - SCREEN[1]) // 2}")
    fit(*SCREEN)
    deadline = time.time() + 90

    def tick():
        rect = hmi_client_rect()
        if rect:
            x, y, w, h = rect
            root.geometry(f"{w}x{h}+{x}+{y}")
            fit(w, h)
        if hmi_ready(port) or time.time() > deadline:
            root.destroy()
            return
        root.after(250, tick)

    tick()
    root.mainloop()


if __name__ == "__main__":
    if sys.argv[1:] == ["--test"]:
        _test()
    else:
        show(sys.argv[1], int(sys.argv[2]))
