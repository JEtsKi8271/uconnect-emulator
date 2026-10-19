"""Pull the named PNGs out of the stock Performance Pages xlet (LWUIT .res bundles) into ./assets/<bundle>/.

    python extract_assets.py <path to 7DEC7834-...jar> [out folder, default ./assets]
    python extract_assets.py <path to 6BFD02C0-...jar> assets_wk     # the Jeep/Viper "SRT Performance Pages"
LWUIT image entry: 0xFD, name (u16 len + UTF-8), 0xF1, u32 length, PNG bytes.
"""
import os, re, struct, sys, zipfile

HERE = os.path.dirname(os.path.abspath(__file__))
ENTRY = re.compile(rb"\xfd(..)([\x20-\x7e]+?)\xf1(....)(?=\x89PNG)", re.S)

z = zipfile.ZipFile(sys.argv[1])
total = 0
for res in [n for n in z.namelist() if n.endswith(".res") and not n.endswith(("fonts.res", "localization.res"))]:
    d = z.read(res)
    out = os.path.join(HERE, sys.argv[2] if len(sys.argv) > 2 else "assets", os.path.splitext(res)[0].replace("/", "_"))
    os.makedirs(out, exist_ok=True)
    for m in ENTRY.finditer(d):
        name = m.group(2).decode()
        if struct.unpack(">H", m.group(1))[0] != len(name):
            continue
        size = struct.unpack(">I", m.group(3))[0]
        data = d[m.end():m.end() + size]
        if not name.lower().endswith(".png"):
            name += ".png"
        open(os.path.join(out, name), "wb").write(data)
        total += 1
print(total, "images")
