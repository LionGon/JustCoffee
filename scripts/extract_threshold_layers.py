#!/usr/bin/env python3
"""Extract full-canvas 1920x1080 alpha layers from threshold composite (ISSUE-602).

Each layer copies pixels inside a bounding box; everything else is transparent.
Run after hotspot bboxes are tuned in docs/THRESHOLD_APARTMENT_C0.md.
"""
from __future__ import annotations

from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
COMPOSITE = ROOT / "assets/backgrounds/threshold_apartment_cycle0.png"
OUT_DIR = ROOT / "assets/backgrounds/layers"

# (x1, y1, x2, y2) inclusive pixel bounds on 1920x1080 composite.
# Tune using threshold_apartment_cycle0_hotspot_debug.png (yellow=CURRENT, green=DETECT).
LAYER_BBOXES: dict[str, tuple[int, int, int, int]] = {
    "threshold_window_cycle0": (0, 0, 425, 710),
    "threshold_plant_cycle0": (137, 496, 356, 683),
    "threshold_mug_cycle0": (140, 657, 411, 829),
    "threshold_phone_cycle0": (456, 742, 843, 923),
    "threshold_vinyl_cycle0": (1296, 456, 1909, 823),
}


def extract_layer(composite: Image.Image, bbox: tuple[int, int, int, int]) -> Image.Image:
    x1, y1, x2, y2 = bbox
    rgba = Image.new("RGBA", composite.size, (0, 0, 0, 0))
    crop = composite.crop((x1, y1, x2 + 1, y2 + 1)).convert("RGBA")
    rgba.paste(crop, (x1, y1))
    return rgba


def main() -> None:
    composite = Image.open(COMPOSITE).convert("RGBA")
    if composite.size != (1920, 1080):
        raise SystemExit(f"Expected 1920x1080 composite, got {composite.size}")

    OUT_DIR.mkdir(parents=True, exist_ok=True)
    for name, bbox in LAYER_BBOXES.items():
        out_path = OUT_DIR / f"{name}.png"
        layer = extract_layer(composite, bbox)
        layer.save(out_path, optimize=True)
        print(f"wrote {out_path.name} bbox={bbox}")


if __name__ == "__main__":
    main()
