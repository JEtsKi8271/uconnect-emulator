"""Performance Pages app layer: redraws the stock xlet's pages (its own artwork, layout from the decompiled
com.sprint.gskills views) in a child window of the HMI window, at the xlet's screen area, while the HMI has the
app (AMS) layer switched on. Like the car's separate xlet graphics plane, it is part of the head-unit screen.

    python app.py "<HMI window title>" <panel port>

Coordinates are the xlet's form space: 624x333 at (11,40) of the 640x480 screen; drawn at the HMI's scale.
"""
import ctypes, glob, json, math, os, subprocess, sys, tempfile, threading, time, urllib.request
from ctypes import wintypes
from PIL import Image, ImageDraw

HERE = os.path.dirname(os.path.abspath(__file__))
ASSETS = os.path.join(HERE, "assets")
TITLE, PORT = sys.argv[1], int(sys.argv[2])
FORM_X, FORM_Y, FORM_W, FORM_H = 11, 40, 624, 333
STR = json.load(open(os.path.join(HERE, "strings_en.json"), encoding="utf-8"))
PAGE = (90, 43)  # page origin, right of the 85px menu
CLOSE = (532, 5, 620, 51)  # the HMI's app close button (AppsActiveScreen close_button), form units
MENU = [("menu_Home", "home", 47, "top"), ("menu_Timers", "timers", 48, "mid"), ("menu_GaugesOne", "gauges1", 47, "mid"),
        ("menu_GaugesTwo", "gauges2", 47, "mid"), ("menu_Gforce", "gforce", 48, "mid"), ("menu_Engine", "engine", 48, "bottom")]
# metric ranges from the xlet's valueRange.properties
RANGES = {"oil_t": (70, 160), "trans_t": (50, 160), "cool_t": (75, 125), "iat": (-20, 120), "ic_t": (-20, 120),
          "batt": (10, 18), "boost_kpa": (0, 250), "afr": (9, 18), "oil_p_kpa": (0, 700)}
# Titles as on the car (2014 Uconnect "SRT Performance Pages" guide screenshots)
TITLES = {"cool_t": "Coolant Temp", "oil_t": "Oil Temp", "oil_p_kpa": "Oil Pressure", "batt": "Battery Voltage",
          "trans_t": "Trans Oil Temp", "iat": "Intake Air Temp", "ic_t": "I/C Coolant Temp",
          "boost_kpa": "Boost Pressure", "afr": "Air Fuel Ratio"}
FACES = {"cool_t": "coolant-temp", "oil_t": "oil-temp", "oil_p_kpa": "oil-pressure", "batt": "battery-voltage",
         "trans_t": "trans-oil-temp", "iat": "intake-air-temp", "ic_t": "intercooler-temp",
         "boost_kpa": "boost-pressure", "afr": "air-fuel-ratio"}
GAUGES = {  # trim -> page -> [(data key, (x, y))]: a dial is 180 wide from x, its face at x+18
    "srt": {"gauges1": [("cool_t", (7, 60)), ("oil_t", (177, 60)), ("oil_p_kpa", (344, 60))],
            "gauges2": [("batt", (7, 60)), ("iat", (177, 60)), ("trans_t", (344, 60))]},
    "hellcat": {"gauges1": [("cool_t", (-8, -5)), ("oil_t", (163, -5)), ("oil_p_kpa", (340, -5)),
                            ("batt", (85, 133)), ("trans_t", (257, 133))],
                "gauges2": [("boost_kpa", (17, -5)), ("afr", (227, -5)), ("ic_t", (122, 133)), ("iat", (332, 133))]},
}
GAUGES["rt"] = GAUGES["srt"]
# Jeep (WK, "SRT Performance Pages" xlet 6BFD02C0): half-arc 200x90 gauges, GaugesOne/TwoView.initJeepViperLayout
GAUGES_WK = {"gauges1": [("oil_t", (173, 15)), ("cool_t", (36, 145)), ("oil_p_kpa", (296, 145))],
             "gauges2": [("batt", (173, 15)), ("iat", (36, 145)), ("trans_t", (296, 145))]}
# CommonTimerView.addTimerSummaryRows: groups with a 7px gap; the brake pair is not on the "Best" ticket
TIMER_GROUPS = [[("Reaction Time", "reaction")], [("0-60  ET", "et60"), ("0-100 ET", "et100")],
                [("1/8 ET", "eighth"), ("1/8 MPH", "eighth_mph")], [("1/4 ET", "quarter"), ("1/4 MPH", "quarter_mph")],
                [("Brake Distance ft", "brake_ft"), ("Brake from mph", "brake_from")]]
# run title colour and the button lit for it, as in the guide: Current red, Last orange, Best green
RUNS = {"current": ("Current", (0xE1, 0x00, 0x00), "btn_srt_red.png"),
        "last": ("Last", (0xEE, 0x90, 0x09), "btn_srt_yellow.png"),
        "best": ("Best", (0x11, 0x77, 0x05), "btn_srt_green.png")}
TIMER_BTN_X, TIMER_BTN_Y, TIMER_BTN_DY = 362, 45, 60  # Current, Last, Best, Save
RED, ORANGE, GREY = (0xFF, 0x00, 0x00), (0xE1, 0xB6, 0x59), (0x4A, 0x4A, 0x4A)
FONTS, FONT_DIR = {}, {}
for _d in ("fonts", "fonts_viper"):  # the L-series/Jeep app's fonts; the Viper app's own ("Size_NN")
    _f = os.path.join(HERE, _d, "fonts.json")
    if os.path.exists(_f):
        for _n, _m in json.load(open(_f, encoding="utf-8")).items():
            FONTS[_n], FONT_DIR[_n] = _m, _d
FONT_SIZES = {fam: sorted(int(n.split("_")[1]) for n in FONTS if n.startswith(fam + "_"))
              for fam in ("Serpentine", "Avenir", "NesobriteBold", "Size")}
EMU = os.path.dirname(HERE)
import viper  # noqa: E402  (uses the font tables above)


# ---------------------------------------------------------------- HMI window tracking
# The AIR window is DPI-unaware; this process stays unaware too so both use the same pixels.
# Plain Win32 (no toolkit): toolkits manage their own top-level windows and fight being a foreign child.
u32, gdi = ctypes.windll.user32, ctypes.windll.gdi32
LRESULT = ctypes.c_ssize_t
WNDPROC = ctypes.WINFUNCTYPE(LRESULT, wintypes.HWND, wintypes.UINT, wintypes.WPARAM, wintypes.LPARAM)
u32.DefWindowProcW.argtypes = [wintypes.HWND, wintypes.UINT, wintypes.WPARAM, wintypes.LPARAM]
u32.DefWindowProcW.restype = LRESULT
u32.CreateWindowExW.argtypes = [wintypes.DWORD, wintypes.LPCWSTR, wintypes.LPCWSTR, wintypes.DWORD, ctypes.c_int,
                                ctypes.c_int, ctypes.c_int, ctypes.c_int, wintypes.HWND, wintypes.HMENU,
                                wintypes.HINSTANCE, wintypes.LPVOID]
u32.CreateWindowExW.restype = wintypes.HWND
u32.GetWindowLongW.argtypes = [wintypes.HWND, ctypes.c_int]
u32.SetWindowLongW.argtypes = [wintypes.HWND, ctypes.c_int, ctypes.c_long]
u32.BeginPaint.restype = wintypes.HDC
u32.FindWindowExW.argtypes = [wintypes.HWND, wintypes.HWND, wintypes.LPCWSTR, wintypes.LPCWSTR]
u32.FindWindowExW.restype = wintypes.HWND
GWL_STYLE, WS_CHILD, WS_CLIPSIBLINGS, WS_CLIPCHILDREN = -16, 0x40000000, 0x04000000, 0x02000000
WM_DESTROY, WM_PAINT, WM_ERASEBKGND, WM_TIMER, WM_LBUTTONDOWN = 0x2, 0xF, 0x14, 0x113, 0x201


class WNDCLASSW(ctypes.Structure):
    _fields_ = [("style", wintypes.UINT), ("lpfnWndProc", WNDPROC), ("cbClsExtra", ctypes.c_int),
                ("cbWndExtra", ctypes.c_int), ("hInstance", wintypes.HINSTANCE), ("hIcon", wintypes.HICON),
                ("hCursor", wintypes.HANDLE), ("hbrBackground", wintypes.HBRUSH), ("lpszMenuName", wintypes.LPCWSTR),
                ("lpszClassName", wintypes.LPCWSTR)]


class PAINTSTRUCT(ctypes.Structure):
    _fields_ = [("hdc", wintypes.HDC), ("fErase", wintypes.BOOL), ("rcPaint", wintypes.RECT),
                ("fRestore", wintypes.BOOL), ("fIncUpdate", wintypes.BOOL), ("rgbReserved", ctypes.c_byte * 32)]


def hmi_window():
    h = u32.FindWindowW("ApolloRuntimeContentWindow", TITLE)
    if not h or not u32.IsWindowVisible(h):
        return None, None
    r = wintypes.RECT()
    u32.GetClientRect(h, ctypes.byref(r))
    return h, (r.right, r.bottom)


# ---------------------------------------------------------------- drawing
class BitmapFont:
    """An LWUIT bitmap font from the xlet's fonts.res (extract_fonts.py): glyph strip + cut offsets/widths."""

    def __init__(self, name):
        meta = FONTS[name]
        self.strip = Image.open(os.path.join(HERE, FONT_DIR[name], name + ".png")).getchannel("R")  # glyph mask in red
        self.h = self.strip.height
        self.glyphs = dict(zip(meta["charset"], zip(meta["offsets"], meta["widths"])))
        self.space = self.glyphs.get(" ", (0, max(2, self.h // 4)))[1]

    def mask(self, text):
        parts = [self.glyphs.get(c) or self.glyphs.get(c.upper()) for c in text]
        w = sum(g[1] if g else self.space for g in parts)
        out, x = Image.new("L", (max(1, w), self.h), 0), 0
        for g in parts:
            if g:
                out.paste(self.strip.crop((g[0], 0, g[0] + g[1], self.h)), (x, 0))
                x += g[1]
            else:
                x += self.space
        return out


_bitmap_fonts = {}


def bitmap_font(family, size):
    sizes = FONT_SIZES[family]
    name = f"{family}_{min(sizes, key=lambda n: abs(n - size))}"
    if name not in _bitmap_fonts:
        _bitmap_fonts[name] = BitmapFont(name)
    return _bitmap_fonts[name]


_wallpapers = {}


def wallpaper(theme):
    """The head unit theme's 640x480 wallpaper (the xlet's pages are see-through), from the theme SWF via ffdec;
    cached in perfpages/cache. None until it is ready (extracted in the background on first use)."""
    if not theme or theme in _wallpapers:
        return _wallpapers.get(theme)
    _wallpapers[theme] = None
    cache = os.path.join(HERE, "cache", theme.replace("/", "_").replace(".swf", ".png"))
    if os.path.exists(cache):
        _wallpapers[theme] = Image.open(cache).convert("RGB")
        return _wallpapers[theme]

    def extract():
        swf = os.path.join(EMU, "hmi", "skins", "default", "themeSwfs", theme)
        ffdec = os.path.join(EMU, "..", "tools", "ffdec", "ffdec.jar")
        if not (theme and os.path.exists(swf) and os.path.exists(ffdec)):
            return
        out = tempfile.mkdtemp()
        subprocess.run(["java", "-jar", ffdec, "-export", "image", out, swf], capture_output=True, timeout=120,
                       creationflags=getattr(subprocess, "CREATE_NO_WINDOW", 0))
        found = glob.glob(os.path.join(out, "**", "*Wallpaper*"), recursive=True)
        if found:
            os.makedirs(os.path.dirname(cache), exist_ok=True)
            im = Image.open(max(found, key=os.path.getsize)).convert("RGB").resize((640, 480))
            im.save(cache)
            _wallpapers[theme] = im
    threading.Thread(target=extract, daemon=True).start()
    return None


class Painter:
    def __init__(self, scale):
        self.s = scale
        self.cache = {}
        self.fonts = {}

    def px(self, v):
        return int(round(v * self.s))

    def img(self, name, *folders):
        key = (name, folders)
        if key not in self.cache:
            im = None
            for f in folders + ("common_common_graphics", "la_la_common"):
                p = os.path.join(ASSETS, f, name)
                if os.path.exists(p):
                    im = Image.open(p).convert("RGBA")
                    # premultiplied, or transparent pixels' colour bleeds into the edges as specks
                    im = im.convert("RGBa").resize((self.px(im.width), self.px(im.height)), Image.LANCZOS).convert("RGBA")
                    break
            self.cache[key] = im
        return self.cache[key]

    family = "Serpentine"  # GSkillsFontsStyleFactory: SRT/Hellcat/Jeep use Serpentine, R/T Avenir

    def paste(self, canvas, im, x, y):
        if im is not None:
            canvas.alpha_composite(im, (self.px(x), self.px(y)))

    def text(self, d, xy, s, size, fill=(255, 255, 255), anchor="mm", bold=True, family=None):
        """Draw s in the xlet's bitmap font of about `size` px (the font names' sizes: 11..46) onto d's image.
        anchor: horizontal l/m/r + vertical t/m/b, like PIL's."""
        if not s:
            return
        key = (family or self.family, size, s)
        m = self.fonts.get(key)
        if m is None:
            m = bitmap_font(family or self.family, size).mask(s)
            m = m.resize((max(1, self.px(m.width)), max(1, self.px(m.height))), Image.LANCZOS)
            if len(self.fonts) > 600:  # values change every frame: keep the cache bounded
                self.fonts.clear()
            self.fonts[key] = m
        x, y = self.px(xy[0]), self.px(xy[1])
        x -= {"l": 0, "m": m.width // 2, "r": m.width}[anchor[0]]
        y -= {"t": 0, "m": m.height // 2, "b": m.height, "s": m.height}[anchor[1]]
        ink = Image.new("RGBA", m.size, tuple(fill) + (255,))
        ink.putalpha(m)
        d._image.alpha_composite(ink, (max(0, x), max(0, y)), (max(0, -x), max(0, -y)))

    def rotated(self, canvas, im, at, pivot, deg):
        """Paste im with its pivot at canvas point `at` (form units), rotated deg clockwise."""
        if im is None:
            return
        pv = (self.px(pivot[0]), self.px(pivot[1]))
        size = 2 * max(im.width, im.height)
        tmp = Image.new("RGBA", (size, size), (0, 0, 0, 0))
        tmp.alpha_composite(im, (size // 2 - pv[0], size // 2 - pv[1]))
        tmp = tmp.rotate(-deg, resample=Image.BICUBIC, center=(size // 2, size // 2))
        canvas.alpha_composite(tmp, (self.px(at[0]) - size // 2, self.px(at[1]) - size // 2))


def frac(v, lo, hi):
    return max(0.0, min(1.0, (v - lo) / (hi - lo)))


def img_no(v, lo, hi, n):
    """CommonSensorModel.getImageNumber: frame 1..n over the analog range."""
    return n if v >= hi else 1 if v < lo else int((v - lo) / ((hi - lo) / n) + 1)


def needle_deg(v, lo, hi):
    return -28 + frac(v, lo, hi) * 236  # RotatingLSeriesGaugeNeedle / EngOilPressureNeedle angle range


def display(key, v, us):
    """(text, unit) for a metric sensor value in the user's units, like the xlet's labels."""
    if key in ("oil_t", "trans_t", "cool_t", "iat", "ic_t"):
        return (f"{v * 9 / 5 + 32:.0f}", STR["unit_US_Temp"]) if us else (f"{v:.0f}", STR["unit_M_Temp"])
    if key == "oil_p_kpa":
        return (f"{v * 0.145038:.0f}", STR["unit_US_OilPressure"]) if us else (f"{v / 100:.1f}", STR["unit_M_OilPressure"])
    if key == "boost_kpa":  # absolute kPa in; gauge pressure out, vacuum in in.Hg like the xlet
        g = v - 101.3
        if us:
            return (f"{g * 0.145038:.1f}", "psi") if g >= 0 else (f"{-g * 0.2953:.1f}", STR["unit_US_BoostPressure"])
        return f"{g:.0f}", STR["unit_M_BoostPressure_PU_Zero"]
    if key == "batt":
        return f"{v:.1f}", STR["unit_US_batteryVoltage"]
    if key == "afr":
        return f"{v:.1f}", ":1"
    return f"{v:.0f}", ""


class App:
    def __init__(self, hmi):
        # A child window of the HMI window: clipped to it, moves and minimises with it, and is destroyed with it
        # (HMI restart), which ends this process.
        self.page, self.home_i, self.timer_tab = "home", 1, "current"
        self.data, self.painter, self.geom, self.shown, self.frame = {}, None, None, False, None
        # one layer per HMI window: an older one (left from an earlier run) is closed, the newest wins
        old = u32.FindWindowExW(hmi, None, "UconnectPerfPages", None)
        while old:
            u32.PostMessageW(old, 0x10, 0, 0)  # WM_CLOSE
            old = u32.FindWindowExW(hmi, old, "UconnectPerfPages", None)
        self.hmi = hmi
        self._proc = WNDPROC(self.wndproc)  # keep a reference: Windows calls it
        wc = WNDCLASSW(lpfnWndProc=self._proc, lpszClassName="UconnectPerfPages",
                       hCursor=u32.LoadCursorW(None, ctypes.c_void_p(32512)))
        u32.RegisterClassW(ctypes.byref(wc))
        self.hwnd = u32.CreateWindowExW(0, "UconnectPerfPages", "Performance Pages", WS_CHILD | WS_CLIPSIBLINGS,
                                        0, 0, 1, 1, hmi, None, None, None)
        u32.SetWindowLongW(hmi, GWL_STYLE, u32.GetWindowLongW(hmi, GWL_STYLE) | WS_CLIPCHILDREN)  # AIR must not paint over it
        u32.SetTimer(self.hwnd, 1, 60, None)

    def run(self):
        msg = wintypes.MSG()
        while u32.GetMessageW(ctypes.byref(msg), None, 0, 0) > 0:
            u32.TranslateMessage(ctypes.byref(msg))
            u32.DispatchMessageW(ctypes.byref(msg))

    def wndproc(self, h, m, w, l):
        try:
            if m == WM_TIMER:
                self.tick()
                return 0
            if m == WM_PAINT:
                self.paint(h)
                return 0
            if m == WM_ERASEBKGND:
                return 1
            if m == WM_LBUTTONDOWN:
                self.click(ctypes.c_short(l & 0xFFFF).value, ctypes.c_short((l >> 16) & 0xFFFF).value)
                return 0
            if m == 0x10:  # WM_CLOSE
                u32.DestroyWindow(h)
                return 0
            if m == WM_DESTROY:
                u32.PostQuitMessage(0)
                return 0
        except Exception as e:  # a drawing bug must not take the layer down
            print("perfpages:", repr(e), file=sys.stderr)
        return u32.DefWindowProcW(h, m, w, l)

    def paint(self, h):
        ps = PAINTSTRUCT()
        dc = u32.BeginPaint(h, ctypes.byref(ps))
        if self.frame is not None:
            w, hh = self.frame.size
            bmi = (ctypes.c_uint32 * 10)(40, w, ctypes.c_uint32(-hh).value, 1 | (32 << 16), 0, 0, 0, 0, 0, 0)
            gdi.SetDIBitsToDevice(dc, 0, 0, w, hh, 0, 0, 0, hh, self.frame.convert("RGB").tobytes("raw", "BGRX"), bmi, 0)
        u32.EndPaint(h, ctypes.byref(ps))

    # ---------------------------------------------------------- loop
    def tick(self):
        try:
            with urllib.request.urlopen(f"http://127.0.0.1:{PORT}/api/perf", timeout=0.5) as r:
                self.data = json.load(r)
        except OSError:
            self.data = {}
        h, rect = hmi_window()
        if h and h != self.hmi:  # the HMI window this layer lives in is gone (head unit restarted): quit,
            u32.DestroyWindow(self.hwnd)  # the backend starts a fresh layer for the new window
            return
        if self.data.get("visible") and rect:
            self.place(h, rect)
            self.render()
            u32.InvalidateRect(self.hwnd, None, False)
            if not self.shown:
                u32.ShowWindow(self.hwnd, 5)  # SW_SHOW
                self.shown = True
        elif self.shown:
            u32.ShowWindow(self.hwnd, 0)  # SW_HIDE
            self.shown = False
            self.page = "home"

    def place(self, h, rect):
        w, hgt = rect
        s = w / 640
        if not self.painter or abs(self.painter.s - s) > 1e-3:
            self.painter = Painter(s)
        g = (round(FORM_X * s), round(FORM_Y * s), round(FORM_W * s), round(FORM_H * s))
        if g != self.geom:  # HMI client coordinates
            u32.MoveWindow(self.hwnd, *g, True)
            # AppsActiveScreen's close button is on the HMI layer, above the app on the car: leave it uncovered
            p, rgn = self.painter, gdi.CreateRectRgn(0, 0, g[2], g[3])
            hole = gdi.CreateRectRgn(p.px(CLOSE[0]), p.px(CLOSE[1]), p.px(CLOSE[2]), p.px(CLOSE[3]))
            gdi.CombineRgn(rgn, rgn, hole, 4)  # RGN_DIFF
            gdi.DeleteObject(hole)
            u32.SetWindowRgn(self.hwnd, rgn, True)  # the window owns rgn now
            self.geom = g

    # ---------------------------------------------------------- input
    def click(self, cx, cy):
        if not self.painter:
            return
        x, y = cx / self.painter.s, cy / self.painter.s
        if self.data.get("line") == "zd":
            return viper.click(self, x, y)
        top = 44
        for key, page, hgt, _ in MENU:
            if 5 <= x < 90 and top <= y < top + hgt:
                self.page = page
                return
            top += hgt
        px, py = x - PAGE[0], y - PAGE[1]
        if self.page == "home" and 250 <= py < 285:
            if 392 <= px < 452:
                self.home_i = 6 if self.home_i == 1 else self.home_i - 1
            elif 462 <= px < 522:
                self.home_i = 1 if self.home_i == 6 else self.home_i + 1
        elif self.page == "timers" and TIMER_BTN_X <= px < TIMER_BTN_X + 156:
            for i, tab in enumerate(("current", "last", "best", "save")):
                if TIMER_BTN_Y + i * TIMER_BTN_DY <= py < TIMER_BTN_Y + i * TIMER_BTN_DY + 46:
                    if tab == "save":
                        self.saved = time.time()  # the car writes the ticket to USB/SD; here: just the confirmation
                    else:
                        self.timer_tab = tab

    # ---------------------------------------------------------- pages
    def render(self):
        p, d = self.painter, self.data
        trim, line = d.get("trim", "srt"), d.get("line", "la")
        if line == "zd":  # the Viper's own app (SRT Performance Pages v1.23): perfpages/viper.py
            self.frame = viper.render(self)
            return
        trim_dir = f"{line}_{line}_{trim}"
        p.family = "Avenir" if trim == "rt" else "Serpentine"
        cv = Image.new("RGBA", (p.px(FORM_W), p.px(FORM_H)), (0, 0, 0, 255))
        wp = wallpaper(d.get("theme", ""))
        if wp is not None:  # the HMI theme behind the app's see-through pages, as on the car
            if getattr(self, "_wp_key", None) != (id(wp), p.s):
                self._wp = wp.crop((FORM_X, FORM_Y, FORM_X + FORM_W, FORM_Y + FORM_H)).resize(cv.size).convert("RGBA")
                self._wp_key = (id(wp), p.s)
            cv.alpha_composite(self._wp)
        draw = ImageDraw.Draw(cv)
        page = Image.new("RGBA", (p.px(528), p.px(285)), (0, 0, 0, 0))
        pd = ImageDraw.Draw(page)
        getattr(self, "page_" + self.page)(page, pd, d, trim, line, trim_dir)
        cv.alpha_composite(page, (p.px(PAGE[0]), p.px(PAGE[1])))
        top = 44
        for key, name, hgt, kind in MENU:
            p.paste(cv, p.img(f"btn-{kind}-{'on' if name == self.page else 'off'}.png"), 5, top)
            p.text(draw, (47, top + hgt / 2), STR[key], 14)
            top += hgt
        p.paste(cv, p.img(f"border-bottom-{line}.png"), 0, 299)
        p.paste(cv, p.img(f"border-top-{line}-{'rt' if trim == 'rt' else 'srt'}.png"), 0, 0)
        self.frame = cv

    def page_home(self, cv, d_, d, trim, line, td):
        p = self.painter
        p.paste(cv, p.img(f"home_{line}_{trim}_{self.home_i}.png", td), 0, 0)
        p.paste(cv, p.img("btn-home-prev-off.png"), 392, 250)
        p.paste(cv, p.img("btn-home-next-off.png"), 462, 250)

    def _gauges(self, cv, dr, d, trim, line, td, which):
        p, us = self.painter, d.get("units") == "US"
        if line == "wk":
            return self._gauges_wk(cv, dr, d, td, which, us)
        for key, (gx, gy) in GAUGES[trim][which]:
            face = FACES[key]
            if trim == "rt":
                names = [f"{line}-rt-{face}.png"]
            else:
                suffix = {"oil_p_kpa": ["psi"] if us else ["kPa", "bar"], "boost_kpa": ["psi"] if us else ["kPa", "bar"]}.get(
                    key, ["us"] if us else ["m"])
                names = [f"{line}-{trim}-{face}-{s}.png" for s in suffix] + [f"{line}-{trim}-{face}.png"]
            im = next((i for i in (p.img(n, td) for n in names) if i is not None), None)
            lo, hi = RANGES[key]
            v = d.get(key, lo)
            # the needle sits under the dial artwork: it shows through the face's window, the hub covers its pivot
            if line == "lx":  # the 300: 30 pre-drawn needle frames (DashboardViewContainer.setImage, getImageNumber(30))
                p.paste(cv, p.img(f"needle-small-lx-{img_no(v, lo, hi, 30)}.png", "lx_lx_common"), gx + 57, gy + 41)
            else:
                p.rotated(cv, p.img(f"needle-small-{line}.png"), (gx + 59 + 32, gy + 40 + 32), (32, 32), needle_deg(v, lo, hi))
            p.paste(cv, im, gx + 18, gy)
            txt, unit = display(key, v, us)
            txt = txt.split(".")[0] if key == "batt" else txt
            p.text(dr, (gx + 90, gy + 103), txt, 24)  # in the dial's lower window, like the cluster
            p.text(dr, (gx + 91, gy + 119), "" if key == "afr" else unit, 11, fill=(220, 220, 220))
            p.text(dr, (gx + 90, gy + 141), TITLES[key], 16)

    def _gauges_wk(self, cv, dr, d, td, which, us):
        """DashboardViewContainer.initJeepViperViewLayout: a white arc (needle_small_wk_mask) turns -132..0 deg about
        (100,105) inside the 200x90 gauge, the corner overlay hides its tail, the dial face goes on top."""
        p = self.painter
        for key, (gx, gy) in GAUGES_WK[which]:
            face = FACES[key]
            suffix = {"oil_p_kpa": ["psi"] if us else ["kPa", "bar"]}.get(key, ["us"] if us else ["m"])
            names = [f"wk-srt-{face}-{s}.png" for s in suffix] + [f"wk-srt-{face}.png"]
            im = next((i for i in (p.img(n, td) for n in names) if i is not None), None)
            lo, hi = RANGES[key]
            v = d.get(key, lo)
            g = Image.new("RGBA", (p.px(200), p.px(90)), (0, 0, 0, 0))  # the needle component clips to 200x90
            p.rotated(g, p.img("needle_small_wk_mask.png", td), (100, 105), (100, 105), -132 + 132 * frac(v, lo, hi))
            p.paste(g, p.img("needle_small_wk_overlay.png", td), 0, 0)
            p.paste(g, im, 0, 0)
            cv.alpha_composite(g, (p.px(gx), p.px(gy)))
            txt, unit = display(key, v, us)
            p.text(dr, (gx + 108, gy + 88), txt, 22, anchor="rm")
            p.text(dr, (gx + 113, gy + 90), unit, 14, fill=(200, 200, 200), anchor="lm")
            p.text(dr, (gx + 100, gy + 112), TITLES[key], 18)

    def page_gauges1(self, *a):
        self._gauges(*a, "gauges1")

    def page_gauges2(self, *a):
        self._gauges(*a, "gauges2")

    def page_engine(self, cv, dr, d, trim, line, td):
        p, us = self.painter, d.get("units") == "US"
        bg = None
        for n in ([f"{line}_{trim}_psi.png"] if us else [f"{line}_{trim}_kPa.png", f"{line}_{trim}_bar.png"]) + [f"{line}_{trim}.png"]:
            bg = bg or p.img(n, td)
        # EngineOilPressureContainer: needle first, then the page artwork over it; Hellcat shows boost there
        hellcat, wk = trim == "hellcat", line == "wk"
        pkey = "boost_kpa" if hellcat else "oil_p_kpa"
        if wk:  # Jeep/Viper: the page artwork, then one of 25 pre-drawn needle frames over it (getImageNumber(25))
            p.paste(cv, bg, 0, 5)
            n = max(1, min(25, int(frac(d.get(pkey, 0), *RANGES[pkey]) * 25) + 1))
            p.paste(cv, p.img(f"needle-large-wk-{n}.png", "wk_wk_common"), 68, 2)
        elif line == "lx":  # the 300: 30 needle frames at (175,101) under the artwork
            p.paste(cv, p.img(f"needle-large-lx-{img_no(d.get(pkey, 0), *RANGES[pkey], 30)}.png", "lx_lx_common"), 175, 101)
            p.paste(cv, bg, 0, 0)
        else:
            p.rotated(cv, p.img(f"needle-large-{line}.png"), (175 + 66, 101 + 66), (66, 66),
                      needle_deg(d.get(pkey, 0), *RANGES[pkey]))
            p.paste(cv, bg, 0, 0)
        hp_max = 560 if trim == "hellcat" else 375  # Max_HorsePower(_Hellcat) / Max_Torque(_Hellcat) in valueRange
        tq_max = 950 if trim == "hellcat" else 675
        self._arc(cv, p.img("hp.png"), (67, -3), (171, 168), 170, 272, frac(d.get("hp", 0) * 0.7457, 0, hp_max))
        self._arc(cv, p.img("torque.png"), (67, -3), (171, 168), 164, 264, frac(d.get("tq", 0) * 1.356, 0, tq_max))
        if not wk:  # the hp / torque arcs' unit labels at their ends (EngineHPTorqueUnitContainer)
            p.paste(cv, p.img("gaugelabel_hp_hp.png" if us else "gaugelabel_hp_KW.png"), 77, 206)
            p.paste(cv, p.img("gaugelabel_torque_ft-lb.png" if us else "gaugelabel_torque_Nm.png"), 102, 206)
        # EngineSpeedContainer: vehicle speed, top left
        spd = d.get("speed_mph", 0)
        p.text(dr, (20, 33), f"{spd:.0f}" if us else f"{spd * 1.609:.0f}", 46, anchor="lm")
        p.text(dr, (112, 20), "mph" if us else "km/h", 14, anchor="lm")
        # Horsepower (red) and Torque (orange), right-aligned on the right
        hp, tq = d.get("hp", 0), d.get("tq", 0)
        p.text(dr, (322, 13), STR["engine_title_horsepower"], 18, fill=RED, anchor="lm")
        p.text(dr, (495, 46), f"{hp:.0f}" if us else f"{hp * 0.7457:.0f}", 46, fill=RED, anchor="rm")
        p.text(dr, (499, 54), "hp" if us else "kW", 18, fill=RED, anchor="lm")
        p.text(dr, (393, 84), STR["engine_title_Torque"], 18, fill=ORANGE, anchor="lm")
        p.text(dr, (480, 112), f"{tq:.0f}" if us else f"{tq * 1.356:.0f}", 28, fill=ORANGE, anchor="rm")
        p.text(dr, (484, 115), "ft/lb" if us else "Nm", 18, fill=ORANGE, anchor="lm")
        # the dial's own value (boost on a Hellcat, oil pressure otherwise) and its name bottom right
        val, unit = display(pkey, d.get(pkey, 0), us)
        val = val.split(".")[0] if us and pkey == "boost_kpa" else val
        if wk:  # EngineGearContainer.initJeepViperGearContainer: the gear sits in the dial's hub
            p.text(dr, (240, 165), str(d.get("gear", 1)) if d.get("trans", "Automatic") == "Automatic" else "N", 42)
            p.text(dr, (240, 190), STR["engine_title_gear"].lower(), 14)
            p.text(dr, (393, 140), "Oil Pressure", 18, anchor="lm")
            p.text(dr, (500, 165), f"{val} {unit}", 18, anchor="rm")
            return
        p.text(dr, (238, 232), val, 46)
        p.text(dr, (239, 255), unit.upper(), 14)
        p.paste(cv, p.img("oil-gauge-pointer.png"), 356, 259)
        p.text(dr, (374, 265), "Boost Pressure" if hellcat else "Oil Pressure", 16, anchor="lm")
        if d.get("trans", "Automatic") == "Automatic":  # EngineGearContainer (automatic only), right-aligned
            p.paste(cv, p.img("automatic-gear-label-bg.png"), 299, 166)
            p.text(dr, (508, 186), STR["engine_title_gear"], 18, anchor="rm")
            p.text(dr, (506, 216), str(d.get("gear", 1)), 46, anchor="rm")

    def _arc(self, cv, im, at, center, a0, a1, f):
        """Reveal f of an arc image from angle a0 toward a1 (PIL degrees, clockwise from +x)."""
        if im is None or f <= 0.005:
            return
        p = self.painter
        mask = Image.new("L", im.size, 0)
        c = (p.px(center[0]), p.px(center[1]))
        r = max(im.size)
        ImageDraw.Draw(mask).pieslice((c[0] - r, c[1] - r, c[0] + r, c[1] + r), a0, a0 + (a1 - a0) * f, fill=255)
        piece = im.copy()
        piece.putalpha(Image.composite(im.getchannel("A"), mask, mask))
        cv.alpha_composite(piece, (p.px(at[0]), p.px(at[1])))

    def page_gforce(self, cv, dr, d, trim, line, td):
        p, us = self.painter, d.get("units") == "US"
        p.paste(cv, p.img("gforce-background-black.png"), 0, 0)
        lat, lon = d.get("lat_g", 0.0), d.get("long_g", 0.0)
        li = min(7, round(abs(lat) * 7))  # Max_Gforces_forImage = 1 g
        lo = min(4, round(abs(lon) * 4))
        if li == 0 and lo == 0:
            ind = "image_gindicator_active.png"
        elif li >= lo:
            ind = f"image_gindicator_active_{'l' if lat < 0 else 'r'}{li}.png"
        else:
            ind = f"image_gindicator_active_{'front' if lon > 0 else 'rear'}{lo}.png"
        p.paste(cv, p.img(ind), 44, 30)
        k = round(max(-1.0, min(1.0, lat)) * 7)
        car = f"{line}_{trim}_mid.png" if k == 0 else (f"{line}_{trim}_l{-k}.png" if k < 0 else f"{line}_{trim}_r{8 - k}.png")
        p.paste(cv, p.img(car, td), 117, 30)
        peak = d.get("peak", {})
        g = STR["unit_US_Gforce"]
        for label, v, pk, xy in (("", -lat if lat < 0 else 0, peak.get("left", 0), (50, 150)),
                                 ("", lat if lat > 0 else 0, peak.get("right", 0), (478, 150)),
                                 ("", lon if lon > 0 else 0, peak.get("accel", 0), (264, 20)),
                                 ("", -lon if lon < 0 else 0, peak.get("brake", 0), (264, 268))):
            p.text(dr, xy, f"{v:.2f} {g}", 18)
            p.text(dr, (xy[0], xy[1] + 16), f"{STR['gforce_title_peak']} {pk:.2f}", 11, fill=(255, 150, 40))
        spd = d.get("speed_mph", 0)
        p.text(dr, (520, 40), f"{spd:.0f} {STR['unit_US_Speed']}" if us else f"{spd * 1.609:.0f} {STR['unit_M_Speed']}",
               22, anchor="rm")
        p.text(dr, (520, 82), f"{STR['Gforce_SteeringAngel'].replace('[]', ' ')} {d.get('steer_deg', 0):+.0f}°", 14,
               anchor="rm")

    def page_timers(self, cv, dr, d, trim, line, td):
        """CommonTimerView: the run ticket (website, run title, ruled line, timer rows) and the run buttons."""
        p, us = self.painter, d.get("units") == "US"
        title, colour, lit = RUNS[self.timer_tab]
        p.paste(cv, p.img("image_timeslip.png"), 10, 2)
        p.text(dr, (155, 19), "DODGE.com" if trim == "rt" else "driveSRT.com", 14, fill=GREY)
        p.text(dr, (155, 44), title, 35, fill=colour)
        dr.line((p.px(46), p.px(60), p.px(263), p.px(60)), fill=(0, 0, 0), width=max(1, p.px(1.5)))
        tab = d.get("timers", {}).get(self.timer_tab, {})
        if time.time() - getattr(self, "saved", 0) < 3:
            p.text(dr, (155, 150), "Run Saved", 22, fill=(0, 0, 0))
        else:
            y = 77
            groups = TIMER_GROUPS[:-1] if self.timer_tab == "best" else TIMER_GROUPS
            for group in groups:
                for label, key in group:
                    p.text(dr, (46, y), label, 18, fill=(0, 0, 0), anchor="lm")
                    v = tab.get(key)
                    if key == "reaction":
                        txt, col = ("--" if v is None else f"+ {v:.1f}"), (0x11, 0x77, 0x05)
                    else:
                        if v is not None and not us:  # metric run titles/units: km/h, m
                            v = v * 1.609 if key.endswith("mph") or key == "brake_from" else v * 0.3048 if key == "brake_ft" else v
                        txt = "--" if v is None else (f"{v:.1f}" if key in ("et60", "et100", "eighth", "quarter") else f"{v:.0f}")
                        col = (0xE1, 0x00, 0x00)
                        p.text(dr, (226, y), "-", 18, fill=(0, 0, 0))
                    p.text(dr, (240, y), txt, 18, fill=col, anchor="lm")
                    y += 19
                y += 8
        for i, name in enumerate(("current", "last", "best", "save")):
            y = TIMER_BTN_Y + i * TIMER_BTN_DY
            p.paste(cv, p.img(lit if name == self.timer_tab else "btn_srt_active.png"), TIMER_BTN_X, y)
            p.text(dr, (TIMER_BTN_X + 78, y + 23), STR.get(f"timer_state_{name.capitalize()}", "Save"), 18)


if __name__ == "__main__":
    for _ in range(300):  # started with the app; the HMI window is normally already there
        hmi, _rect = hmi_window()
        if hmi:
            break
        time.sleep(0.1)
    else:
        sys.exit("HMI window not found: " + TITLE)
    App(hmi).run()
