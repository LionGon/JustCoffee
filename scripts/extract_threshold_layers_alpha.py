#!/usr/bin/env python3
"""Extract Le Seuil Cycle 0 layers with real alpha (ISSUE-602).

Pipeline:
  1. Bboxes from threshold_apartment_cycle0.gd (HOTSPOT_RECTS) or Gemma4 via Ollama.
  2. plant / mug / phone / vinyl: rembg on padded crop → full-canvas 1920×1080 PNG.
  3. window: full-frame bbox alpha (rembg destroys glass/city — not suitable).

Requires: pip install rembg pillow onnxruntime

Usage:
  python3 scripts/extract_threshold_layers_alpha.py
  python3 scripts/extract_threshold_layers_alpha.py --no-rembg   # rectangular fallback
"""
from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
COMPOSITE = ROOT / "assets/backgrounds/threshold_apartment_cycle0.png"
OUT_DIR = ROOT / "assets/backgrounds/layers"
GD_SCRIPT = ROOT / "scenes/districts/threshold/threshold_apartment_cycle0.gd"
DEBUG_OUT = ROOT / "assets/backgrounds/threshold_apartment_cycle0_layers_debug.png"
CANVAS_W = 1920
CANVAS_H = 1080

LAYER_ORDER: list[tuple[str, str, bool]] = [
    ("threshold_window_cycle0", "window", False),
    ("threshold_plant_cycle0", "plant", True),
    ("threshold_mug_cycle0", "mug", True),
    ("threshold_phone_cycle0", "phone", True),
    ("threshold_vinyl_cycle0", "vinyl", True),
]


def load_hotspot_rects() -> dict[str, tuple[int, int, int, int]]:
    text = GD_SCRIPT.read_text()
    match = re.search(
        r'const HOTSPOT_RECTS: Dictionary = \{(.*?)\}',
        text,
        re.DOTALL,
    )
    if not match:
        raise SystemExit(f"HOTSPOT_RECTS not found in {GD_SCRIPT}")

    rects: dict[str, tuple[int, int, int, int]] = {}
    for line in match.group(1).splitlines():
        m = re.search(
            r'"(\w+)":\s*Rect2i\((\d+),\s*(\d+),\s*(\d+),\s*(\d+)\)',
            line,
        )
        if m:
            name, x, y, w, h = m.groups()
            rects[name] = (int(x), int(y), int(w), int(h))
    if not rects:
        raise SystemExit("No Rect2i entries parsed from HOTSPOT_RECTS")
    return rects


def extract_rect_layer(composite: Image.Image, x: int, y: int, w: int, h: int) -> Image.Image:
    layer = Image.new("RGBA", composite.size, (0, 0, 0, 0))
    crop = composite.crop((x, y, x + w, y + h)).convert("RGBA")
    layer.paste(crop, (x, y))
    return layer


def extract_rembg_layer(
    composite: Image.Image,
    x: int,
    y: int,
    w: int,
    h: int,
    pad: int,
    remove_fn,
) -> Image.Image:
    x1 = max(0, x - pad)
    y1 = max(0, y - pad)
    x2 = min(CANVAS_W, x + w + pad)
    y2 = min(CANVAS_H, y + h + pad)
    crop = composite.crop((x1, y1, x2, y2))
    cutout = remove_fn(crop)
    if cutout.mode != "RGBA":
        cutout = cutout.convert("RGBA")
    layer = Image.new("RGBA", composite.size, (0, 0, 0, 0))
    layer.paste(cutout, (x1, y1), cutout)
    return layer


def write_debug_overlay(layers: dict[str, Image.Image]) -> None:
    base = Image.open(COMPOSITE).convert("RGBA")
    for name in ("threshold_plant_cycle0", "threshold_mug_cycle0", "threshold_phone_cycle0", "threshold_vinyl_cycle0"):
        layer = layers[name]
        # Tint visible pixels for stacking check
        tinted = Image.new("RGBA", layer.size, (0, 0, 0, 0))
        px = layer.load()
        tp = tinted.load()
        for yy in range(layer.height):
            for xx in range(layer.width):
                r, g, b, a = px[xx, yy]
                if a > 20:
                    tp[xx, yy] = (r, g, b, min(200, a))
        base = Image.alpha_composite(base, tinted)
    base.save(DEBUG_OUT)
    print(f"layers debug → {DEBUG_OUT.relative_to(ROOT)}")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--no-rembg",
        action="store_true",
        help="Skip rembg; export rectangular crops only",
    )
    parser.add_argument("--pad", type=int, default=40, help="Padding around rembg crops")
    args = parser.parse_args()

    if not COMPOSITE.is_file():
        print(f"Missing composite: {COMPOSITE}", file=sys.stderr)
        return 1

    composite = Image.open(COMPOSITE).convert("RGBA")
    if composite.size != (CANVAS_W, CANVAS_H):
        print(f"Expected {CANVAS_W}x{CANVAS_H}, got {composite.size}", file=sys.stderr)
        return 1

    rects = load_hotspot_rects()
    remove_fn = None
    if not args.no_rembg:
        try:
            from rembg import remove as remove_fn  # noqa: PLC0415
        except ImportError:
            print(
                "rembg not installed. Run: pip install rembg pillow onnxruntime\n"
                "Falling back to rectangular alpha.",
                file=sys.stderr,
            )
            args.no_rembg = True

    OUT_DIR.mkdir(parents=True, exist_ok=True)
    written: dict[str, Image.Image] = {}

    for file_name, hotspot_id, use_rembg in LAYER_ORDER:
        if hotspot_id not in rects:
            print(f"Missing hotspot '{hotspot_id}' in HOTSPOT_RECTS", file=sys.stderr)
            return 1
        x, y, w, h = rects[hotspot_id]
        if use_rembg and not args.no_rembg and remove_fn is not None:
            layer = extract_rembg_layer(composite, x, y, w, h, args.pad, remove_fn)
            mode = "rembg"
        else:
            layer = extract_rect_layer(composite, x, y, w, h)
            mode = "rect"
        out_path = OUT_DIR / f"{file_name}.png"
        layer.save(out_path, optimize=True)
        written[file_name] = layer
        alpha = layer.split()[-1]
        bbox = alpha.getbbox()
        print(f"wrote {out_path.name} [{mode}] rect=({x},{y},{w},{h}) alpha_bbox={bbox}")

    write_debug_overlay(written)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
