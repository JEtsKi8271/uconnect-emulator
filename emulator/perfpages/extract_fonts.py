"""Pull the bitmap fonts out of the stock Performance Pages xlet (LWUIT common/fonts.res) into ./fonts/.

    python extract_fonts.py <path to 7DEC7834-...jar> [out folder] [.res inside the jar]
    python extract_fonts.py <GSkills_Viper jar> fonts_viper CommonResources.res

LWUIT font entry: 0xFC, name (UTF), fallback byte, truetype flag, lookup flag [+ lookup UTF], bitmap flag,
image (type byte, int length, PNG), short charCount, charCount x short cutOffset, charCount x byte charWidth,
charset (UTF).
Writes fonts/<name>.png (the glyph strip) and fonts/fonts.json {name: {"charset", "offsets", "widths"}}.
"""
import json, os, re, struct, sys, zipfile

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, sys.argv[2] if len(sys.argv) > 2 else "fonts")
RES = sys.argv[3] if len(sys.argv) > 3 else "common/fonts.res"


def utf(d, i):
    n = struct.unpack(">H", d[i:i + 2])[0]
    return d[i + 2:i + 2 + n].decode("utf-8", "replace"), i + 2 + n


def main(jar):
    d = zipfile.ZipFile(jar).read(RES)
    os.makedirs(OUT, exist_ok=True)
    fonts = {}
    for m in re.finditer(rb"\xfc(?=\x00[\x01-\x40][A-Za-z])", d):
        name, i = utf(d, m.start() + 1)
        if not re.fullmatch(r"[A-Za-z]+_\d+", name):
            continue
        i += 2  # fallback, truetype flag
        if d[i]:  # lookup name follows
            _, i = utf(d, i + 1)
        else:
            i += 1
        if not d[i]:  # no bitmap
            continue
        i += 2  # bitmap flag, image type
        size = struct.unpack(">i", d[i:i + 4])[0]
        png, i = d[i + 4:i + 4 + size], i + 4 + size
        assert png[:4] == b"\x89PNG", name
        count = struct.unpack(">h", d[i:i + 2])[0]
        i += 2
        offsets = list(struct.unpack(f">{count}h", d[i:i + 2 * count]))  # all cut offsets, then all widths
        widths = list(d[i + 2 * count:i + 3 * count])
        i += 3 * count
        charset, i = utf(d, i)
        assert len(charset) == count, (name, len(charset), count)
        open(os.path.join(OUT, name + ".png"), "wb").write(png)
        fonts[name] = {"charset": charset, "offsets": offsets, "widths": widths}
    json.dump(fonts, open(os.path.join(OUT, "fonts.json"), "w", encoding="utf-8"), ensure_ascii=False)
    print(len(fonts), "fonts:", ", ".join(sorted(fonts)))


if __name__ == "__main__":
    main(sys.argv[1])
