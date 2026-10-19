"""Validate the upload image formats and package the completed assets."""
import json
from pathlib import Path
import struct
import zipfile

root = Path(__file__).resolve().parent
sizes = {
    "iphone-duo-outer": (1398, 2034),
    "iphone-duo-inner": (2007, 2853),
    "iphone-dynamic-island-large": (1320, 2868),
    "iphone-face-id-large": (1284, 2778),
    "iphone-dynamic-island-medium": (1206, 2622),
    "iphone-face-id-medium": (1170, 2532),
    "iphone-home-button-large": (1242, 2208),
    "iphone-home-button-medium": (750, 1334),
    "ipad-13": (2064, 2752),
    "ipad-12.9": (2048, 2732),
    "ipad-11": (1668, 2420),
    "ipad-10.5": (1668, 2224),
    "ipad-9.7": (1536, 2048),
    "watch-ultra": (422, 514),
}
results = []
for path in sorted(root.rglob("*.png")):
    data = path.read_bytes()
    assert data[:8] == b"\x89PNG\r\n\x1a\n", path
    width, height, depth, color = struct.unpack(">IIBB", data[16:26])
    assert color == 2, f"Alpha channel or non-RGB format: {path}"
    assert depth == 8, path
    if path.parent.parent.name == "screenshots":
        assert (width, height) == sizes[path.parent.name], path
    if path.parent.name == "headers":
        assert (width, height) in [(5244, 2950), (3840, 1646)], path
    results.append(dict(file=str(path.relative_to(root)), width=width, height=height,
                        bit_depth=depth, color_type=color, opaque=True))

assert len(list((root / "screenshots").rglob("*.png"))) == 68
(root / "validation.json").write_text(json.dumps(
    dict(png_count=len(results), screenshots=68, headers=2, files=results), indent=2) + "\n")
archive = root.parent / "KinAround-App-Store-Assets.zip"
with zipfile.ZipFile(archive, "w", compression=zipfile.ZIP_DEFLATED) as output:
    for path in sorted(root.rglob("*")):
        if path.is_file():
            output.write(path, Path("store-assets") / path.relative_to(root))
print(f"Validated {len(results)} opaque RGB PNGs; packaged 68 screenshots and 2 headers.")
