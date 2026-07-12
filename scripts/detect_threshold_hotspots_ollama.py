#!/usr/bin/env python3
"""Detect Le Seuil hotspot bboxes via Ollama vision (gemma4:31b).

Gemma often returns coordinates on a 0-1000 scale; this script scales to 1920x1080,
writes a debug overlay PNG, and prints Godot Rect2i lines.

Usage:
  python3 scripts/detect_threshold_hotspots_ollama.py
  python3 scripts/detect_threshold_hotspots_ollama.py --model gemma4:31b --apply
"""
from __future__ import annotations

import argparse
import base64
import json
import re
import sys
import urllib.error
import urllib.request
from pathlib import Path

from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parents[1]
COMPOSITE = ROOT / "assets/backgrounds/threshold_apartment_cycle0.png"
DEBUG_OUT = ROOT / "assets/backgrounds/threshold_apartment_cycle0_gemma4_debug.png"
GD_SCRIPT = ROOT / "scenes/districts/threshold/threshold_apartment_cycle0.gd"
OLLAMA_URL = "http://localhost:11434/api/chat"
CANVAS_W = 1920
CANVAS_H = 1080

PROMPT = """This image is exactly {w}x{h} pixels (width x height).

Locate these 5 clickable game objects and return ONLY valid JSON (no markdown, no explanation):
{{
  "window": {{"x": int, "y": int, "w": int, "h": int}},
  "plant": {{"x": int, "y": int, "w": int, "h": int}},
  "mug": {{"x": int, "y": int, "w": int, "h": int}},
  "phone": {{"x": int, "y": int, "w": int, "h": int}},
  "vinyl": {{"x": int, "y": int, "w": int, "h": int}}
}}

Rules:
- Coordinate system: top-left origin, (x,y) = top-left corner of tight bounding box.
- Use a 0-1000 normalized scale (0=left/top, 1000=right/bottom of image).
- window: large left window including frame and glass.
- plant: potted plant on windowsill only.
- mug: white coffee mug on foreground counter (left).
- phone: smartphone on counter with lit screen.
- vinyl: turntable/record player on right shelf.
"""


def _extract_json(text: str) -> dict:
    text = text.strip()
    fence = re.search(r"```(?:json)?\s*(\{.*?\})\s*```", text, re.DOTALL)
    if fence:
        text = fence.group(1)
    start = text.find("{")
    end = text.rfind("}")
    if start == -1 or end == -1:
        raise ValueError(f"No JSON object in model response: {text[:500]}")
    return json.loads(text[start : end + 1])


def _scale_box(box: dict) -> tuple[int, int, int, int]:
    x = int(round(box["x"] * CANVAS_W / 1000))
    y = int(round(box["y"] * CANVAS_H / 1000))
    w = int(round(box["w"] * CANVAS_W / 1000))
    h = int(round(box["h"] * CANVAS_H / 1000))
    w = max(w, 8)
    h = max(h, 8)
    x = max(0, min(x, CANVAS_W - 1))
    y = max(0, min(y, CANVAS_H - 1))
    if x + w > CANVAS_W:
        w = CANVAS_W - x
    if y + h > CANVAS_H:
        h = CANVAS_H - y
    return x, y, w, h


def query_ollama(model: str, image_path: Path) -> dict:
    b64 = base64.b64encode(image_path.read_bytes()).decode("ascii")
    payload = {
        "model": model,
        "stream": False,
        "messages": [
            {
                "role": "user",
                "content": PROMPT.format(w=CANVAS_W, h=CANVAS_H),
                "images": [b64],
            }
        ],
    }
    req = urllib.request.Request(
        OLLAMA_URL,
        data=json.dumps(payload).encode(),
        headers={"Content-Type": "application/json"},
        method="POST",
    )
    with urllib.request.urlopen(req, timeout=300) as resp:
        data = json.loads(resp.read().decode())
    content: str = data["message"]["content"]
    return _extract_json(content)


def write_debug_overlay(boxes: dict[str, tuple[int, int, int, int]]) -> None:
    img = Image.open(COMPOSITE).convert("RGBA")
    draw = ImageDraw.Draw(img)
    for name, (x, y, w, h) in boxes.items():
        draw.rectangle([x, y, x + w, y + h], outline=(100, 200, 255, 255), width=3)
        draw.text((x + 4, y + 4), f"{name} gemma4", fill=(100, 200, 255, 255))
    img.save(DEBUG_OUT)
    print(f"debug overlay → {DEBUG_OUT.relative_to(ROOT)}")


def format_godot_const(boxes: dict[str, tuple[int, int, int, int]]) -> str:
    lines = ["const HOTSPOT_RECTS: Dictionary = {"]
    for name, (x, y, w, h) in boxes.items():
        lines.append(f'\t"{name}": Rect2i({x}, {y}, {w}, {h}),')
    lines.append("}")
    return "\n".join(lines)


def apply_to_gdscript(boxes: dict[str, tuple[int, int, int, int]]) -> None:
    text = GD_SCRIPT.read_text()
    pattern = re.compile(r"const HOTSPOT_RECTS: Dictionary = \{.*?\}", re.DOTALL)
    replacement = format_godot_const(boxes)
    if not pattern.search(text):
        raise SystemExit(f"Could not find HOTSPOT_RECTS in {GD_SCRIPT}")
    GD_SCRIPT.write_text(pattern.sub(replacement, text))
    print(f"updated → {GD_SCRIPT.relative_to(ROOT)}")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--model", default="gemma4:31b")
    parser.add_argument("--image", type=Path, default=COMPOSITE)
    parser.add_argument("--apply", action="store_true", help="Write HOTSPOT_RECTS into .gd file")
    args = parser.parse_args()

    if not args.image.is_file():
        print(f"Missing image: {args.image}", file=sys.stderr)
        return 1

    try:
        raw = query_ollama(args.model, args.image)
    except urllib.error.URLError as exc:
        print(f"Ollama request failed (is `ollama serve` running?): {exc}", file=sys.stderr)
        return 1
    except (json.JSONDecodeError, ValueError, KeyError) as exc:
        print(f"Failed to parse model output: {exc}", file=sys.stderr)
        return 1

    boxes = {name: _scale_box(raw[name]) for name in ("window", "plant", "mug", "phone", "vinyl")}
    write_debug_overlay(boxes)
    print(format_godot_const(boxes))
    print("\nRaw 0-1000 response:", json.dumps(raw, indent=2))

    if args.apply:
        apply_to_gdscript(boxes)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
