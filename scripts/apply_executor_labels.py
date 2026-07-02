#!/usr/bin/env python3
"""Apply executor:* and tool:* labels + body section to all GitHub issues."""

import importlib.util
import json
import re
import subprocess
import sys
import time
from pathlib import Path

REPO = "LionGon/JustCoffee"
EXECUTORS_PATH = Path(__file__).resolve().parent / "issue_executors.py"

spec = importlib.util.spec_from_file_location("issue_executors", EXECUTORS_PATH)
executors_mod = importlib.util.module_from_spec(spec)
assert spec.loader is not None
spec.loader.exec_module(executors_mod)

EXECUTOR_MAP = executors_mod.EXECUTOR_MAP
EXECUTOR_LABELS = executors_mod.EXECUTOR_LABELS
TOOL_LABELS = executors_mod.TOOL_LABELS
executor_labels_for = executors_mod.executor_labels_for
executor_section = executors_mod.executor_section

ALL_NEW_LABELS = list(EXECUTOR_LABELS.values()) + list(TOOL_LABELS.values())

LABEL_COLORS: dict[str, str] = {
    "executor:cursor": "1D76DB",
    "executor:human": "B60205",
    "executor:cursor+human": "FBCA04",
    "tool:godot": "5319E7",
    "tool:dialogic": "C5DEF5",
    "tool:daw": "F9D0C4",
    "tool:art": "FEF2C0",
    "tool:github": "EDEDED",
    "tool:audacity": "D4C5F9",
}


def run(args: list[str], check: bool = True) -> subprocess.CompletedProcess[str]:
    return subprocess.run(["gh", *args], capture_output=True, text=True)


def ensure_labels() -> None:
    existing = run(["label", "list", "--repo", REPO, "--limit", "200"], check=False)
    names = set(existing.stdout.splitlines()) if existing.returncode == 0 else set()
    for label in ALL_NEW_LABELS:
        if label in names:
            continue
        run(
            [
                "label",
                "create",
                label,
                "--repo",
                REPO,
                "--color",
                LABEL_COLORS.get(label, "BFDADC"),
                "--description",
                label.split(":", 1)[1],
                "--force",
            ],
            check=False,
        )
        time.sleep(0.1)


def merge_body(current_body: str, section: str) -> str:
    if "## Executor & tools" in current_body:
        return re.sub(
            r"## Executor & tools\n.*?(?=\n## |\Z)",
            section.strip(),
            current_body,
            count=1,
            flags=re.DOTALL,
        )
    return current_body.rstrip() + "\n\n" + section


def main() -> None:
    ensure_labels()

    listing = run(
        ["issue", "list", "--repo", REPO, "--limit", "100", "--state", "all", "--json", "number,title,body,labels"],
    )
    issues = json.loads(listing.stdout)

    updated = 0
    for issue in sorted(issues, key=lambda i: i["number"]):
        number = issue["number"]
        if number not in EXECUTOR_MAP:
            print(f"Skip #{number}: no executor mapping")
            continue

        spec = EXECUTOR_MAP[number]
        want_labels = executor_labels_for(spec)
        current = {label["name"] for label in issue["labels"]}
        to_add = [label for label in want_labels if label not in current]

        for label in to_add:
            result = run(
                ["issue", "edit", str(number), "--repo", REPO, "--add-label", label],
                check=False,
            )
            if result.returncode != 0:
                print(f"#{number} label {label} failed: {result.stderr}", file=sys.stderr)
            time.sleep(0.15)

        new_body = merge_body(issue["body"] or "", executor_section(spec))
        if new_body != (issue["body"] or ""):
            result = run(
                ["issue", "edit", str(number), "--repo", REPO, "--body", new_body],
                check=False,
            )
            if result.returncode != 0:
                print(f"#{number} body update failed: {result.stderr}", file=sys.stderr)
            time.sleep(0.2)

        updated += 1
        print(f"#{number}: {spec.primary} | tools={','.join(spec.tools) or 'none'} | +{len(to_add)} labels")

    print(f"\nUpdated {updated} issues.")


if __name__ == "__main__":
    main()
