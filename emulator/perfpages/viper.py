"""The Viper's Performance Pages: the stock "SRT Performance Pages" xlet 52c79381 (GSkills_Viper v01.23), an older
app than the L-series/Jeep one: SRT title bar, blue frame, a 4-row menu that pages (Home/Timers/G-Force/Gauges 1 ⌄
Gauges 2/Engine/Options ⌃), pre-drawn gauge frames, and an Options page for the home picture and paint colour.
Layout from the decompiled com.sprint.gskills views (decomp/perfpages_viper); artwork in assets_viper/.

Form units like app.py: 624x333 at (11,40) of the 640x480 screen.
"""
import json, os, sys, time

HERE = os.path.dirname(os.path.abspath(__file__))
OPTIONS_FILE = os.path.join(HERE, "cache", "viper_options.json")
COLORS = ["strykerred", "yellow", "shadowblue", "gunmetal", "bluepearlcoat", "black", "white"]  # resKey carTheme_zd_*
MENU = [["Home", "Timers", "G-Force", "Gauges 1"], ["Gauges 2", "Engine", "Options"]]
PAGE_OF = {"Home": "home", "Timers": "timers", "G-Force": "gforce", "Gauges 1": "gauges1", "Gauges 2": "gauges2",
           "Engine": "engine", "Options": "options"}
TITLE_H, FRAME = 51, (4, 51)  # title bar height; the content frame (617x275) origin
PAGE = (FRAME[0] + 87, FRAME[1] + 2)  # page area (530x271) right of the 83px menu
# valueRange.properties (US units, as the app shows them) and getImageNumber(17)
RANGE_US = {"oil_t": (120, 320), "cool_t": (140, 260), "iat": (0, 250), "batt": (10, 18), "oil_p": (0, 100)}
GREY, WHITE, RED, GOLD = (0x7F, 0x7F, 0x7F), (255, 255, 255), (255, 0, 0), (0xE1, 0xB6, 0x59)


def _m(a):
    return sys.modules[type(a).__module__]  # app.py (run as __main__)


def load_options():
    try:
        return json.load(open(OPTIONS_FILE, encoding="utf-8"))
    except (OSError, ValueError):
        return {"home": 0, "color": 0}


def save_options(o):
    os.makedirs(os.path.dirname(OPTIONS_FILE), exist_ok=True)
    json.dump(o, open(OPTIONS_FILE, "w", encoding="utf-8"))


def state(a):
    if not hasattr(a, "viper"):
        o = load_options()
        a.viper = {"menu_page": 0, "page": "home", "timer": "current", "opt": dict(o), "saved": o, "flash": 0}
    return a.viper


def us_values(d):
    """The app's own value set, in US units: (value text, gauge fraction)."""
    f = lambda c: c * 9 / 5 + 32
    v = {"oil_t": f(d.get("oil_t", 0)), "cool_t": f(d.get("cool_t", 0)), "iat": f(d.get("iat", 0)),
         "batt": d.get("batt", 0), "oil_p": d.get("oil_p_kpa", 0) * 0.145038}
    return v


def frame_no(v, lo, hi, n):
    """CommonSensorModel.getImageNumber: 1..n slots over the analog range."""
    if v >= hi:
        return n
    if v < lo:
        return 1
    return int((v - lo) / ((hi - lo) / n) + 1)


# ---------------------------------------------------------------- drawing
def render(a):
    m, p, d, st = _m(a), a.painter, a.data, state(a)
    Image, ImageDraw = m.Image, m.ImageDraw
    p.family = "Size"
    img = lambda n: p.img(n, "../assets_viper/GSkillsTheme", "../assets_viper/CommonResources")
    cv = Image.new("RGBA", (p.px(m.FORM_W), p.px(m.FORM_H)), (0, 0, 0, 255))
    dr = ImageDraw.Draw(cv)
    # MainTitleView: white bursts above and below the SRT breadcrumb
    p.paste(cv, img("white_burst_top.png"), -3, 0)
    p.paste(cv, img("image_srt_breadcrumb.png"), (m.FORM_W - 265) / 2, 6)
    p.paste(cv, img("white_burst_btm.png"), -3, 43)
    fx, fy = FRAME
    if st["page"] == "home":  # the chosen home picture fills the frame (backgroundImgContainer, home only)
        p.paste(cv, img(f"bg_options_{st['saved']['home'] + 1}.png"), fx + 2, fy + 2)
    # the frame: west strip (menu backdrop) + north/south/east lines
    p.paste(cv, img("modal_srt_west.png"), fx, fy)
    p.paste(cv, img("modal_srt_north.png"), fx + 89, fy)
    p.paste(cv, img("modal_srt_south.png"), fx + 89, fy + 272)
    p.paste(cv, img("modal_srt_east.png"), fx + 614, fy + 3)
    page = Image.new("RGBA", (p.px(530), p.px(271)), (0, 0, 0, 0))
    pd = ImageDraw.Draw(page)
    globals()["page_" + st["page"]](a, m, p, page, pd, d, st, img)
    cv.alpha_composite(page, (p.px(PAGE[0]), p.px(PAGE[1])))
    # MainMenuView: 4 buttons (top/centre styles) and the paging button
    items = MENU[st["menu_page"]]
    y = fy + 2
    for i in range(4):
        name = items[i] if i < len(items) else ""
        kind = "1" if i == 0 else "2"
        on = name and PAGE_OF[name] == st["page"]
        p.paste(cv, img(f"btn_srtnav_{kind}_{'pressed' if on else 'active'}.png"), fx + 2, y)
        p.text(dr, (fx + 2 + 41.5, y + 27), name, 14)
        y += 54
    p.paste(cv, img("btn_srtnav_3_active.png"), fx + 2, y)
    arrow = img("ico_more_down.png" if st["menu_page"] == 0 else "ico_more_up.png")
    if arrow is not None:
        p.paste(cv, arrow, fx + 2 + (83 - arrow.width / p.s) / 2, y + 2 + (54 - arrow.height / p.s) / 2)
    return cv


def page_home(a, m, p, cv, dr, d, st, img):
    pass  # the picture is the frame's background


def _gauge(m, p, cv, dr, img, x, y, kind, title, key, v, unit):
    """DashboardViewContainer: title, frame (image_gauge1of3/1of5_<1..17>), mid value, big value, min/max, unit."""
    lo, hi = RANGE_US[key]
    if kind == 1:
        W, imgH, mainW, mmW, font, mainY = 222, 90, 122, 50, 42, 61
        mmY = unitY = mainY + 42
    else:
        W, imgH, mainW, mmW, font, mainY = 188, 76, 100, 44, 35, 61
        mmY = mainY + (35 - 18) + 13
        unitY = mmY + 18
    p.text(dr, (x + W / 2, y + 11), title, 18)
    p.paste(cv, img(f"image_gauge1of{3 if kind == 1 else 5}_{frame_no(v, lo, hi, 17)}.png"), x, y + 22)
    p.text(dr, (x + W / 2, y + 43 + 9), f"{(lo + hi) / 2:g}", 18, fill=GREY)
    txt = f"{v:.0f}"
    p.text(dr, (x + mmW + mainW / 2, y + mainY + font / 2), txt, font)
    p.text(dr, (x + 4, y + mmY + 9), f"{lo:g}", 18, fill=GREY, anchor="lm")
    p.text(dr, (x + W - 4, y + mmY + 9), f"{hi:g}", 18, fill=GREY, anchor="rm")
    if unit:
        p.text(dr, (x + W / 2, y + unitY + 11), unit, 18)


def page_gauges1(a, m, p, cv, dr, d, st, img):
    v = us_values(d)
    _gauge(m, p, cv, dr, img, 10, 10, 1, "Oil Temp °F", "oil_t", v["oil_t"], "")
    _gauge(m, p, cv, dr, img, 530 - 222 - 10, 10, 1, "Battery Voltage", "batt", v["batt"], "volts")
    _gauge(m, p, cv, dr, img, 265 - 111, 271 - 125 - 10, 1, "Oil Pressure", "oil_p", v["oil_p"], "psi")


def page_gauges2(a, m, p, cv, dr, d, st, img):
    v = us_values(d)
    _gauge(m, p, cv, dr, img, 4, 4, 2, "Oil Temp °F", "oil_t", v["oil_t"], "")
    _gauge(m, p, cv, dr, img, 4, 271 - 107 - 4, 2, "Coolant Temp °F", "cool_t", v["cool_t"], "")
    _gauge(m, p, cv, dr, img, 171, 135 - 129 // 2 - 18, 2, "Oil Pressure", "oil_p", v["oil_p"], "psi")
    _gauge(m, p, cv, dr, img, 338, 4, 2, "Battery Voltage", "batt", v["batt"], "volts")
    _gauge(m, p, cv, dr, img, 338, 271 - 107 - 4, 2, "Intake Air Temp °F", "iat", v["iat"], "")


def page_engine(a, m, p, cv, dr, d, st, img):
    """EngineView: landing background, hp/torque/oil-pressure sweeps (fixed-position frames), values right."""
    ox = 14 - 2  # EngineView margin-left inside the page
    p.paste(cv, img("image_enginelanding_bg.png"), ox, 0)
    hp, tq, oil = d.get("hp", 0), d.get("tq", 0), d.get("oil_p_kpa", 0) * 0.145038
    # Max_HorsePower_US 650, Max_Torque_US 600, Max_OilPressure_US 100 -> 72/72/24 frames
    for name, val, hi, n, (fx, fy) in (("image_hpgauge", hp, 650, 72, (51, 17)),
                                         ("image_torquegauge", tq, 600, 72, (62, 11)),
                                         ("image_oilgauge", oil, 100, 24, (172, 79))):
        if val > 0:
            p.paste(cv, img(f"{name}_{frame_no(val, 0, hi, n)}.png"), ox + fx, fy)
    spd = d.get("speed_mph", 0)
    p.text(dr, (ox + 10 + 8, 6 + 23), f"{spd:.0f}", 46, anchor="lm")
    p.text(dr, (ox + 112, 18), "mph", 14, anchor="lm")
    # EngineMessageContainer: right column, right-aligned at 516
    r = ox + 516
    p.text(dr, (r - 150, 14), "Horsepower", 14, fill=RED, anchor="lm")
    p.text(dr, (r - 42, 44), f"{hp:.0f}", 46, fill=RED, anchor="rm")
    p.text(dr, (r - 38, 52), "hp", 14, fill=RED, anchor="lm")
    p.text(dr, (r - 150, 82), "Torque", 14, fill=GOLD, anchor="lm")
    p.text(dr, (r - 42, 108), f"{tq:.0f}", 35, fill=GOLD, anchor="rm")
    p.text(dr, (r - 38, 114), "ft-lb", 14, fill=GOLD, anchor="lm")
    p.text(dr, (r - 150, 144), "Oil Pressure", 14, anchor="lm")
    p.text(dr, (r - 42, 168), f"{oil:.0f}", 28, anchor="rm")
    p.text(dr, (r - 38, 172), "psi", 14, anchor="lm")
    # the arcs' unit tags at their start, and the gear in the hub (automatic only)
    p.text(dr, (ox + 115, 219), "hp", 14, fill=RED)
    p.text(dr, (ox + 150, 219), "ft-lb", 14, fill=GOLD)
    p.text(dr, (ox + 205, 219), "psi", 14)
    if d.get("trans") == "Automatic":
        p.text(dr, (ox + 263, 160), str(d.get("gear", 1)), 46)
        p.text(dr, (ox + 263, 188), "gear", 14)


def page_gforce(a, m, p, cv, dr, d, st, img):
    """GForceView: g indicator behind, the car (viper_<colour>_l3..r3) leaning with lateral g, values around."""
    col = COLORS[st["saved"]["color"]]
    lat, lon = d.get("lat_g", 0.0), d.get("long_g", 0.0)
    li, lo_ = min(7, round(abs(lat) * 7)), min(4, round(abs(lon) * 4))
    ind = ("image_gindicator_active.png" if li == 0 and lo_ == 0 else
           f"image_gindicator_active_{'l' if lat < 0 else 'r'}{li}.png" if li >= lo_ else
           f"image_gindicator_active_{'front' if lon > 0 else 'rear'}{lo_}.png")
    p.paste(cv, img(ind), 50, 11)
    k = round(max(-1.0, min(1.0, lat)) * 3)
    car = f"viper_{col}_mid.png" if k == 0 else f"viper_{col}_{'l' if k < 0 else 'r'}{abs(k)}.png"
    p.paste(cv, img(car), 118, 18)
    g = lambda v: f"{max(0.0, v):.2f}"
    p.text(dr, (265, 14), g(lon) + " g", 22, fill=(0xE1, 0xE1, 0xE1))
    p.text(dr, (265, 258), g(-lon) + " g", 22, fill=(0xE1, 0xE1, 0xE1))
    p.text(dr, (60, 135), g(-lat) + " g", 22, fill=(0xE1, 0xE1, 0xE1))
    p.text(dr, (470, 135), g(lat) + " g", 22, fill=(0xE1, 0xE1, 0xE1))
    p.text(dr, (520, 20), f"{d.get('speed_mph', 0):.0f} mph", 28, fill=(0xE1, 0xE1, 0xE1), anchor="rm")
    p.text(dr, (520, 52), f"Steering Angle {d.get('steer_deg', 0):+.0f}°", 14, anchor="rm")


TIMER_ROWS = [("0-60 ET", "et60"), ("1/8 ET", "eighth"), ("1/8 mph", "eighth_mph"), ("1/4 ET", "quarter"),
              ("1/4 mph", "quarter_mph"), ("Brake Dist Ft", "brake_ft"), ("Brake from mph", "brake_from")]
RUN = {"current": ("Recent", (0x11, 0x77, 0x05), "btn_srt_green.png"),
       "last": ("Last", (0xEE, 0x90, 0x09), "btn_srt_yellow.png"),
       "best": ("Best", (0xE1, 0x00, 0x00), "btn_srt_red.png")}  # TimersDisplayStatusEnum (Jeep/Viper: "Recent")
TB_X, TB_Y, TB_DY = 23 + 342 + 8, 18, 60


def page_timers(a, m, p, cv, dr, d, st, img):
    """CommonTimerViewContainer: the time slip (run title, "Time Trials", rows) and Current/Last/Best/Save."""
    title, colour, lit = RUN[st["timer"]]
    p.paste(cv, img("image_timeslip.png"), 23, -4)
    tx = 23 + 31
    p.text(dr, (tx + 140, 22), "Current" if st["timer"] == "current" else title, 28, fill=colour)
    p.text(dr, (tx + 140, 42), "Time Trials", 18, fill=(0, 0, 0))
    p.text(dr, (tx + 140, 52), "-" * 26, 14, fill=(0, 0, 0))
    tab = d.get("timers", {}).get(st["timer"], {})
    if time.time() - st["flash"] < 3:
        p.text(dr, (tx + 140, 140), "Run Saved", 22, fill=(0, 0, 0))
    else:
        y = 72
        for label, key in TIMER_ROWS:
            if st["timer"] == "best" and key.startswith("brake"):
                continue
            v = tab.get(key)
            txt = "--" if v is None else (f"{v:.1f}" if "mph" not in key and not key.startswith("brake") else f"{v:.0f}")
            p.text(dr, (tx + 180, y), f"{label} -", 18, fill=(0, 0, 0), anchor="rm")
            p.text(dr, (tx + 186, y), txt, 18, fill=(0xE1, 0, 0), anchor="lm")
            y += 20
    for i, name in enumerate(("current", "last", "best", "save")):
        y = TB_Y + i * TB_DY
        im = img(RUN[name][2] if name == st["timer"] else "btn_srt_active.png")
        p.paste(cv, im, TB_X, y)
        p.text(dr, (TB_X + 78, y + 23), {"current": "Current", "save": "Save"}.get(name, RUN.get(name, ("",))[0]), 18)


def page_options(a, m, p, cv, dr, d, st, img):
    """OptionsView: Select Home Picture / Select Vehicle Color, each with ‹‹ Accept ›› (CommonSelecter)."""
    o = st["opt"]
    for col_x, label, pic in ((20, "Select Home Picture", f"options_homepic_{o['home'] + 1}.png"),
                              (285, "Select Vehicle Color", f"color_options_{COLORS[o['color']]}.png")):
        p.text(dr, (col_x + 113, 22), label, 18)
        if col_x == 20:
            p.paste(cv, img(pic), col_x + 14, 40)
        else:
            p.paste(cv, img(pic), col_x + 13, 44)
            p.paste(cv, img("image_colorbar.png"), col_x + 3, 160)
            bar = img("image_colorbar_selector.png")
            if bar is not None:  # the white selector over the chosen colour's slot
                p.paste(cv, bar, col_x + 3 + o["color"] * 216 / 7, 156)
        x0, y0 = col_x, 190
        p.paste(cv, img("btn_optionleft_active.png"), x0, y0)
        p.paste(cv, img("btn_optioncenter_active.png"), x0 + 60, y0)
        p.paste(cv, img("btn_optionright_active.png"), x0 + 166, y0)
        for ic, ix in (("ico_options_arrow_l.png", x0 + 28), ("ico_options_arrow_r.png", x0 + 194)):
            im = img(ic)
            if im is not None:
                p.paste(cv, im, ix - im.width / p.s / 2, y0 + 18 - im.height / p.s / 2)
        p.text(dr, (x0 + 111, y0 + 18), "Accept", 18)


# ---------------------------------------------------------------- input
def click(a, x, y):
    st = state(a)
    fx, fy = FRAME
    if fx + 2 <= x < fx + 85 and fy + 2 <= y < fy + 2 + 4 * 54 + 58:
        i = int((y - fy - 2) // 54)
        if i >= 4:  # paging button
            st["menu_page"] ^= 1
            return
        items = MENU[st["menu_page"]]
        if i < len(items):
            st["page"] = PAGE_OF[items[i]]
        return
    px, py = x - PAGE[0], y - PAGE[1]
    if st["page"] == "timers" and TB_X <= px < TB_X + 156:
        for i, name in enumerate(("current", "last", "best", "save")):
            if TB_Y + i * TB_DY <= py < TB_Y + i * TB_DY + 46:
                if name == "save":
                    st["flash"] = time.time()
                else:
                    st["timer"] = name
    elif st["page"] == "options" and 190 <= py < 226:
        for col_x, key, n in ((20, "home", 6), (285, "color", len(COLORS))):
            if col_x <= px < col_x + 57:
                st["opt"][key] = (st["opt"][key] - 1) % n
            elif col_x + 166 <= px < col_x + 223:
                st["opt"][key] = (st["opt"][key] + 1) % n
            elif col_x + 60 <= px < col_x + 163:  # Accept: saved like the app's RMS store
                st["saved"][key] = st["opt"][key]
                save_options(st["saved"])
