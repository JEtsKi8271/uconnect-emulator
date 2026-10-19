"""Real sound for the emulator: your music folder as the USB stick, played through Windows MCI (winmm).

scan() builds the media library (tags via mutagen when installed, else folder/file names) and caches it.
run() owns all MCI calls on one thread and keeps playback in step with what the HMI asked for.
"""
import ctypes, json, os, time

EXTS = {".mp3", ".m4a", ".aac", ".wma", ".wav", ".flac"}


# ---------------------------------------------------------------- library
def _tags(path, root):
    """(title, artist, album, genre, year, seconds) for one file; untagged files use <root>/Artist/Album/."""
    stem = os.path.splitext(os.path.basename(path))[0]
    rel = [p for p in os.path.relpath(os.path.dirname(path), root).split(os.sep) if p != "."]
    title, genre, year, secs = stem, "Unknown", 0, 0
    album = rel[-1] if rel else "Unknown Album"
    artist = rel[-2] if len(rel) > 1 else "Unknown Artist"
    try:
        import mutagen
        f = mutagen.File(path, easy=True)
        if f is not None:
            secs = int(getattr(f.info, "length", 0) or 0)
            t = f.tags or {}

            def first(*keys):
                for k in keys:
                    v = t.get(k)
                    if v:
                        v = v[0] if isinstance(v, list) else v
                        return str(getattr(v, "value", v)).strip()
                return ""
            # easy keys (mp3/m4a/flac) first, then WMA (ASF) names
            title = first("title", "Title") or title
            artist = first("artist", "albumartist", "Author", "WM/AlbumArtist") or artist
            album = first("album", "WM/AlbumTitle") or album
            genre = first("genre", "WM/Genre") or genre
            y = first("date", "originaldate", "WM/Year")[:4]
            year = int(y) if y.isdigit() else 0
    except Exception:
        pass  # no mutagen or unreadable tags: keep the name-based guess, the file may still play
    return title, artist, album, genre, year, secs


def scan(music_dir, cache_file):
    """All playable files under music_dir as library tuples (title, artist, album, genre, year, seconds, path)."""
    try:
        cache = json.load(open(cache_file, encoding="utf-8"))
    except (OSError, ValueError):
        cache = {}
    out, fresh = [], {}
    for root, _, files in os.walk(music_dir):
        for name in sorted(files):
            if os.path.splitext(name)[1].lower() not in EXTS:
                continue
            path = os.path.join(root, name)
            try:
                st = os.stat(path)
            except OSError:
                continue
            key = f"{st.st_mtime_ns}:{st.st_size}"
            hit = cache.get(path)
            tags = hit[1] if hit and hit[0] == key else list(_tags(path, music_dir))
            fresh[path] = [key, tags]
            out.append(tuple(tags) + (path,))
    json.dump(fresh, open(cache_file, "w", encoding="utf-8"))
    return sorted(out, key=lambda r: (r[1].lower(), r[2].lower(), r[6].lower()))


# ---------------------------------------------------------------- touch beeps
# The car's DSP synthesises its confirmation tones; no sound files ship in the firmware.
TONES = {"CONF_1": [(2400, 0.035)],                       # normal touch
         "CONF_2": [(700, 0.07), (0, 0.04), (700, 0.07)],  # rejection
         "CONF_3": [(1900, 0.04), (0, 0.02), (2600, 0.05)]}  # setting stored


def make_tones(folder):
    import math, wave
    os.makedirs(folder, exist_ok=True)
    rate = 22050
    for name, parts in TONES.items():
        path = os.path.join(folder, f"{name}.wav")
        if os.path.exists(path):
            continue
        frames = bytearray()
        for hz, sec in parts:
            n = int(rate * sec)
            for i in range(n):
                env = min(1.0, i / 60, (n - i) / 60)  # 3 ms ramps: no clicks
                v = int(9000 * env * math.sin(2 * math.pi * hz * i / rate)) if hz else 0
                frames += v.to_bytes(2, "little", signed=True)
        with wave.open(path, "wb") as w:
            w.setnchannels(1)
            w.setsampwidth(2)
            w.setframerate(rate)
            w.writeframes(bytes(frames))


def tone(folder, name):
    import winsound
    path = os.path.join(folder, f"{name}.wav")
    if os.path.exists(path):
        winsound.PlaySound(path, winsound.SND_FILENAME | winsound.SND_ASYNC | winsound.SND_NODEFAULT)


# ---------------------------------------------------------------- MCI player
class MciError(Exception):
    pass


_winmm = ctypes.windll.winmm if os.name == "nt" else None


def mci(cmd):
    buf = ctypes.create_unicode_buffer(256)
    err = _winmm.mciSendStringW(cmd, buf, 255, None)
    if err:
        msg = ctypes.create_unicode_buffer(256)
        _winmm.mciGetErrorStringW(err, msg, 255)
        raise MciError(f"{cmd!r}: {msg.value}")
    return buf.value


def run(want, report):
    """Playback loop. want() -> {"path", "playing", "start": seconds to open at, "seek": (generation, seconds),
    "volume": (left, right) 0..1000, "ring": path|None}; a new seek generation means "jump to its seconds".
    report(event, **kw): "loaded"(length), "position"(sec), "ended", "failed"(path)."""
    cur = {"path": None, "ok": False, "playing": False, "seek": None, "volume": None, "ring": None}
    while True:
        w = want()
        try:
            if w["path"] != cur["path"]:
                if cur["ok"]:
                    mci("close song")
                # remember a broken file too, so it isn't retried every tick
                cur.update(path=w["path"], ok=False, playing=False, volume=None, seek=w["seek"])
                if w["path"]:
                    try:
                        mci(f'open "{w["path"]}" type mpegvideo alias song')
                        cur["ok"] = True
                        mci("set song time format milliseconds")
                        mci(f"seek song to {int(w['start'] * 1000)}")
                        report("loaded", length=int(mci("status song length") or 0) // 1000)
                    except MciError:
                        report("failed", path=w["path"])
            if cur["ok"]:
                if w["seek"] != cur["seek"]:
                    cur["seek"] = w["seek"]
                    ms = int(w["seek"][1] * 1000)
                    mci(f"play song from {ms}" if cur["playing"] else f"seek song to {ms}")
                if w["playing"] and not cur["playing"]:
                    mci("play song")
                    cur["playing"] = True
                elif not w["playing"] and cur["playing"]:
                    mci("pause song")
                    cur["playing"] = False
                if w["volume"] != cur["volume"]:
                    left, right = w["volume"]
                    mci(f"setaudio song left volume to {left}")
                    mci(f"setaudio song right volume to {right}")
                    cur["volume"] = w["volume"]
                if cur["playing"]:
                    pos, mode = int(mci("status song position") or 0), mci("status song mode")
                    if mode == "stopped" and pos >= int(mci("status song length") or 0) - 250:
                        cur["playing"] = False
                        report("ended")
                    else:
                        report("position", sec=pos // 1000)
            if w["ring"] != cur["ring"]:
                if cur["ring"]:
                    mci("close ring")
                if w["ring"]:
                    mci(f'open "{w["ring"]}" type mpegvideo alias ring')
                    mci("play ring repeat")
                cur["ring"] = w["ring"]
        except MciError as e:
            report("error", msg=str(e))
        time.sleep(0.2)
