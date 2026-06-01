from __future__ import annotations

import colorsys
import glob
import os
import zipfile
from io import BytesIO
from pathlib import Path

from PIL import Image


ROOT = Path(__file__).resolve().parents[1]
OUT_DIR = ROOT / "output" / "vue_spring_recipe_course"
ASSET_DIR = ROOT / "assets" / "vue_spring_recipe_course"
GREEN_ASSET_DIR = ROOT / "assets" / "vue_spring_recipe_course_green"
GREEN_ASSET_DIR.mkdir(parents=True, exist_ok=True)

INPUT = next(
    Path(p)
    for p in glob.glob(str(OUT_DIR / "*.pptx"))
    if not Path(p).name.startswith("~$") and "淡绿色系" not in Path(p).name
)
OUTPUT = OUT_DIR / f"{INPUT.stem}_淡绿色系.pptx"

COLOR_MAP = {
    "FFF7ED": "F3FAF4",
    "FB923C": "A3C9A8",
    "F97316": "7BA985",
    "F59E0B": "9BBF75",
    "EF4444": "5E8C61",
    "FFFBF2": "F8FCF7",
    "F2D7BD": "D9E9D7",
    "FFFBEB": "F4FAF1",
    "FEF3C7": "EAF5DE",
    "FED7AA": "CFE4CD",
    "FFF1E4": "EAF5EA",
    "F5D4B7": "D7EAD5",
    "F4CFB1": "CFE4CD",
}


def replace_colors(data: bytes) -> bytes:
    text = data.decode("utf-8")
    for old, new in COLOR_MAP.items():
        text = text.replace(old, new).replace(old.lower(), new.lower())
    return text.encode("utf-8")


def is_diagram_image(name: str, image: Image.Image) -> bool:
    width, height = image.size
    if width == 120 and height == 120:
        return False
    if width == 1672 and height == 941:
        return False
    return name.lower().endswith(".png")


def recolor_orange_to_green(image: Image.Image) -> Image.Image:
    rgba = image.convert("RGBA")
    pixels = rgba.load()
    width, height = rgba.size
    for y in range(height):
        for x in range(width):
            r, g, b, a = pixels[x, y]
            if a == 0:
                continue
            h, s, v = colorsys.rgb_to_hsv(r / 255, g / 255, b / 255)
            hue = h * 360
            orange_or_yellow = 12 <= hue <= 55 and s > 0.18 and v > 0.35
            warm_pale = 20 <= hue <= 65 and s > 0.08 and v > 0.78 and r >= g >= b
            if orange_or_yellow or warm_pale:
                new_h = 122 / 360
                new_s = min(max(s * 0.72, 0.16), 0.42)
                new_v = min(v * 1.02, 1.0)
                nr, ng, nb = colorsys.hsv_to_rgb(new_h, new_s, new_v)
                pixels[x, y] = (round(nr * 255), round(ng * 255), round(nb * 255), a)
    return rgba


def process_media(name: str, data: bytes) -> bytes:
    if not name.lower().endswith((".png", ".jpg", ".jpeg")):
        return data
    try:
        image = Image.open(BytesIO(data))
    except Exception:
        return data
    if not is_diagram_image(name, image):
        return data
    green = recolor_orange_to_green(image)
    buffer = BytesIO()
    green.save(buffer, format="PNG")
    return buffer.getvalue()


with zipfile.ZipFile(INPUT, "r") as src, zipfile.ZipFile(OUTPUT, "w", zipfile.ZIP_DEFLATED) as dst:
    for item in src.infolist():
        data = src.read(item.filename)
        if item.filename.endswith(".xml") or item.filename.endswith(".rels"):
            data = replace_colors(data)
        elif item.filename.startswith("ppt/media/"):
            data = process_media(item.filename, data)
        dst.writestr(item, data)

for png in ASSET_DIR.glob("*.png"):
    image = Image.open(png)
    if is_diagram_image(png.name, image):
        recolor_orange_to_green(image).save(GREEN_ASSET_DIR / png.name)

print(f"Input: {INPUT}")
print(f"Output: {OUTPUT}")
print(f"Green diagram assets: {GREEN_ASSET_DIR}")
