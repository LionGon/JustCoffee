#!/usr/bin/env python3
"""Apply Start date / Target date to all Just Coffee project items."""

import importlib.util
import json
import subprocess
import sys
import time
from pathlib import Path

SCHEDULE_PATH = Path(__file__).resolve().parent / "roadmap_schedule.py"
spec = importlib.util.spec_from_file_location("roadmap_schedule", SCHEDULE_PATH)
roadmap = importlib.util.module_from_spec(spec)
assert spec.loader is not None
spec.loader.exec_module(roadmap)

SCHEDULE = roadmap.SCHEDULE
PROJECT_NUMBER = roadmap.PROJECT_NUMBER
PROJECT_ID = roadmap.PROJECT_ID
OWNER = roadmap.OWNER
START_FIELD = "PVTF_lAHOA1sLDM4Bb32OzhWlGQI"
TARGET_FIELD = "PVTF_lAHOA1sLDM4Bb32OzhWlGRA"


def run(args: list[str]) -> subprocess.CompletedProcess[str]:
    return subprocess.run(["gh", *args], capture_output=True, text=True)


def load_items() -> dict[int, str]:
    """Map GitHub issue number -> project item node ID."""
    result = run(
        [
            "project",
            "item-list",
            str(PROJECT_NUMBER),
            "--owner",
            OWNER,
            "--limit",
            "100",
            "--format",
            "json",
        ]
    )
    if result.returncode != 0:
        print(result.stderr, file=sys.stderr)
        sys.exit(1)

    mapping: dict[int, str] = {}
    for item in json.loads(result.stdout)["items"]:
        content = item.get("content") or {}
        number = content.get("number")
        item_id = item.get("id")
        if number and item_id:
            mapping[int(number)] = item_id
    return mapping


def set_date(item_id: str, field_id: str, date_value: str) -> None:
    result = run(
        [
            "project",
            "item-edit",
            "--id",
            item_id,
            "--project-id",
            PROJECT_ID,
            "--field-id",
            field_id,
            "--date",
            date_value,
        ]
    )
    if result.returncode != 0:
        print(f"Failed {item_id} {field_id}={date_value}: {result.stderr}", file=sys.stderr)
        sys.exit(1)


def main() -> None:
    items = load_items()
    missing = [num for num in SCHEDULE if num not in items]
    if missing:
        print(f"Warning: schedule entries without project items: {missing}", file=sys.stderr)

    updated = 0
    for issue_number, (start_date, target_date) in sorted(SCHEDULE.items()):
        item_id = items.get(issue_number)
        if not item_id:
            continue
        set_date(item_id, START_FIELD, start_date)
        time.sleep(0.12)
        set_date(item_id, TARGET_FIELD, target_date)
        time.sleep(0.12)
        updated += 1
        print(f"#{issue_number}: {start_date} → {target_date}")

    print(f"\nApplied dates to {updated} items.")
    print(f"Roadmap: https://github.com/users/{OWNER}/projects/{PROJECT_NUMBER}/views/1")


if __name__ == "__main__":
    main()
