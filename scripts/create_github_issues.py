#!/usr/bin/env python3
"""Parse tasks/PRODUCTION_PLAN.md and create GitHub milestones, labels, and issues."""

from __future__ import annotations

import json
import re
import subprocess
import sys
import time
from dataclasses import dataclass, field
from pathlib import Path

REPO = "LionGon/JustCoffee"
PLAN_PATH = Path(__file__).resolve().parent.parent / "tasks" / "PRODUCTION_PLAN.md"

MILESTONES: dict[str, str] = {
    "M0": "M0 — Repository & Godot Init",
    "M1": "M1 — Core Systems",
    "M2": "M2 — Components & Shaders",
    "M3": "M3 — UI & Localization",
    "M4": "M4 — Audio Foundation",
    "M5": "M5 — Art Pipeline",
    "M6": "M6 — Dialogic & Narrative Pipeline",
    "M7": "M7 — Cycle 0 Playable",
    "M8": "M8 — Cycle 1 Playable",
    "M9": "M9 — Vertical Slice Ship",
}

LABELS: list[str] = [
    "area:core",
    "area:components",
    "area:shaders",
    "area:ui",
    "area:audio",
    "area:art",
    "area:narrative",
    "area:scenes",
    "area:infra",
    "area:qa",
    "cycle:0",
    "cycle:1",
    "cycle:future",
    "lang:gdscript",
    "lang:dialogic",
    "lang:shader",
    "priority:critical",
    "priority:high",
    "priority:medium",
    "priority:low",
    "type:feature",
    "type:bug",
    "type:docs",
    "type:asset",
    "human-required",
    "ai-suitable",
    "collaborative",
    "blocked:design",
    "vertical-slice",
]


@dataclass
class IssueSpec:
    issue_id: str
    title: str
    labels: list[str] = field(default_factory=list)
    milestone: str = ""
    depends_on: list[str] = field(default_factory=list)
    body: str = ""


def run_gh(args: list[str], check: bool = True) -> subprocess.CompletedProcess[str]:
    cmd = ["gh", *args]
    result = subprocess.run(cmd, capture_output=True, text=True)
    if check and result.returncode != 0:
        print(f"Command failed: {' '.join(cmd)}", file=sys.stderr)
        print(result.stderr, file=sys.stderr)
        sys.exit(result.returncode)
    return result


def parse_plan(content: str) -> list[IssueSpec]:
    pattern = re.compile(r"^### (ISSUE-\d+) — (.+)$", re.MULTILINE)
    matches = list(pattern.finditer(content))
    issues: list[IssueSpec] = []

    for index, match in enumerate(matches):
        issue_id = match.group(1)
        title = match.group(2).strip()
        start = match.end()
        end = matches[index + 1].start() if index + 1 < len(matches) else len(content)
        block = content[start:end]

        labels_match = re.search(r"\*\*Labels:\*\*\s*(.+)", block)
        labels: list[str] = []
        if labels_match:
            labels = re.findall(r"`([^`]+)`", labels_match.group(1))

        milestone_match = re.search(r"\*\*Milestone:\*\*\s*(M\d+)", block)
        milestone = milestone_match.group(1) if milestone_match else ""

        depends_match = re.search(r"\*\*Depends on:\*\*\s*(.+)", block)
        depends_on: list[str] = []
        if depends_match:
            dep_text = depends_match.group(1).strip()
            if dep_text not in ("—", "-", "—  "):
                depends_on = re.findall(r"ISSUE-\d+", dep_text)

        body_parts: list[str] = [
            f"**Task ID:** `{issue_id}`",
            f"**Source:** [`tasks/PRODUCTION_PLAN.md`](tasks/PRODUCTION_PLAN.md)",
            "",
        ]

        if depends_on:
            dep_links = ", ".join(f"`{dep}`" for dep in depends_on)
            body_parts.append(f"**Depends on:** {dep_links}")
            body_parts.append("")

        for section_name in (
            "Objective",
            "Detailed requirements",
            "Detailed requirements\n",
            "Acceptance criteria",
            "Files",
            "Epics to create",
        ):
            section_pattern = rf"#### {re.escape(section_name.rstrip())}\n(.*?)(?=\n#### |\n---|\Z)"
            section_match = re.search(section_pattern, block, re.DOTALL)
            if section_match:
                section_body = section_match.group(1).strip()
                clean_name = section_name.rstrip()
                body_parts.append(f"## {clean_name}")
                body_parts.append("")
                body_parts.append(section_body)
                body_parts.append("")

        body = "\n".join(body_parts).strip()
        issues.append(
            IssueSpec(
                issue_id=issue_id,
                title=f"{issue_id}: {title}",
                labels=labels,
                milestone=milestone,
                depends_on=depends_on,
                body=body,
            )
        )

    return issues


def ensure_labels() -> None:
    existing = run_gh(["label", "list", "--repo", REPO, "--limit", "200"], check=False)
    existing_names = set(existing.stdout.splitlines()) if existing.returncode == 0 else set()

    for label in LABELS:
        if label in existing_names:
            continue
        color = "ededed"
        if label.startswith("priority:critical"):
            color = "b60205"
        elif label.startswith("priority:high"):
            color = "d93f0b"
        elif label.startswith("priority:medium"):
            color = "fbca04"
        elif label.startswith("priority:low"):
            color = "0e8a16"
        elif label.startswith("area:"):
            color = "1d76db"
        elif label.startswith("type:"):
            color = "5319e7"
        run_gh(["label", "create", label, "--repo", REPO, "--color", color, "--force"], check=False)
        time.sleep(0.15)


def ensure_milestones() -> dict[str, int]:
    listing = run_gh(
        ["api", f"repos/{REPO}/milestones", "--paginate", "-q", ".[] | \"\\(.title)\\t\\(.number)\""],
        check=False,
    )
    title_to_number: dict[str, int] = {}
    if listing.returncode == 0:
        for line in listing.stdout.strip().splitlines():
            if "\t" in line:
                title, number = line.split("\t", 1)
                title_to_number[title] = int(number)

    for milestone_id, title in MILESTONES.items():
        if title not in title_to_number:
            result = run_gh(
                [
                    "api",
                    f"repos/{REPO}/milestones",
                    "-f",
                    f"title={title}",
                    "-f",
                    "state=open",
                ]
            )
            number = json.loads(result.stdout)["number"]
            title_to_number[title] = number
            time.sleep(0.15)

    return {mid: title_to_number[MILESTONES[mid]] for mid in MILESTONES}


def create_issues(issues: list[IssueSpec], milestone_numbers: dict[str, int]) -> dict[str, int]:
    """Returns mapping issue_id -> GitHub issue number."""
    issue_map: dict[str, int] = {}

    listing = run_gh(
        [
            "issue",
            "list",
            "--repo",
            REPO,
            "--limit",
            "200",
            "--json",
            "number,title",
        ],
        check=False,
    )
    existing_titles: dict[str, int] = {}
    if listing.returncode == 0:
        for item in json.loads(listing.stdout):
            existing_titles[item["title"]] = item["number"]

    for spec in issues:
        if spec.title in existing_titles:
            issue_map[spec.issue_id] = existing_titles[spec.title]
            print(f"Skip existing: {spec.issue_id} -> #{existing_titles[spec.title]}")
            continue

        args = [
            "issue",
            "create",
            "--repo",
            REPO,
            "--title",
            spec.title,
            "--body",
            spec.body,
        ]
        for label in spec.labels:
            args.extend(["--label", label])

        if spec.milestone and spec.milestone in milestone_numbers:
            args.extend(["--milestone", MILESTONES[spec.milestone]])

        result = run_gh(args)
        url = result.stdout.strip()
        number = int(url.rsplit("/", 1)[-1])
        issue_map[spec.issue_id] = number
        print(f"Created {spec.issue_id} -> #{number}")
        time.sleep(0.35)

    return issue_map


def add_dependency_comments(issues: list[IssueSpec], issue_map: dict[str, int]) -> None:
    for spec in issues:
        if not spec.depends_on:
            continue
        number = issue_map.get(spec.issue_id)
        if not number:
            continue

        dep_lines = []
        for dep_id in spec.depends_on:
            dep_number = issue_map.get(dep_id)
            if dep_number:
                dep_lines.append(f"- Blocked by #{dep_number} (`{dep_id}`)")

        if not dep_lines:
            continue

        comment = "## Dependencies\n\n" + "\n".join(dep_lines)
        run_gh(
            ["issue", "comment", str(number), "--repo", REPO, "--body", comment],
            check=False,
        )
        time.sleep(0.2)


def create_project() -> str | None:
    """Return project URL if found or created."""
    result = run_gh(
        [
            "project",
            "list",
            "--owner",
            "LionGon",
            "--limit",
            "50",
            "--format",
            "json",
        ],
        check=False,
    )
    project_url: str | None = None
    if result.returncode == 0:
        payload = json.loads(result.stdout)
        projects = payload.get("projects", payload if isinstance(payload, list) else [])
        for project in projects:
            if isinstance(project, dict) and project.get("title") == "Just Coffee":
                project_url = project.get("url")
                print(f"Project already exists: {project_url}")
                break

    if not project_url:
        created = run_gh(
            [
                "project",
                "create",
                "--owner",
                "LionGon",
                "--title",
                "Just Coffee",
                "--format",
                "json",
            ],
            check=False,
        )
        if created.returncode == 0:
            data = json.loads(created.stdout)
            project_url = data.get("url")
            print(f"Created project: {project_url}")

    return project_url


def configure_project_status_columns() -> None:
    """Set Status field to Backlog → Ready → In Progress → Review → Done."""
    query_fields = """
    query {
      user(login: "LionGon") {
        projectV2(number: 8) {
          fields(first: 20) {
            nodes {
              ... on ProjectV2SingleSelectField {
                id
                name
                options { id name }
              }
            }
          }
        }
      }
    }
    """
    result = run_gh(["api", "graphql", "-f", f"query={query_fields}"], check=False)
    if result.returncode != 0:
        print("Warning: could not fetch project fields for status configuration", file=sys.stderr)
        return

    nodes = json.loads(result.stdout)["data"]["user"]["projectV2"]["fields"]["nodes"]
    status_field = next((n for n in nodes if n.get("name") == "Status"), None)
    if not status_field:
        print("Warning: Status field not found on project #8", file=sys.stderr)
        return

    option_ids = {opt["name"]: opt["id"] for opt in status_field.get("options", [])}
    required = ["Backlog", "Ready", "In Progress", "Review", "Done"]
    if all(name in option_ids for name in required):
        print("Project status columns already configured")
        return

    # Preserve existing option IDs when renaming Todo → Backlog, etc.
    backlog_id = option_ids.get("Backlog") or option_ids.get("Todo", "")
    in_progress_id = option_ids.get("In Progress", "")
    done_id = option_ids.get("Done", "")

    options_parts = [
        f'{{ id: "{backlog_id}", name: "Backlog", color: GRAY, description: "Not started" }}'
        if backlog_id
        else '{ name: "Backlog", color: GRAY, description: "Not started" }',
        '{ name: "Ready", color: BLUE, description: "Dependencies met" }',
        f'{{ id: "{in_progress_id}", name: "In Progress", color: YELLOW, description: "Active work" }}'
        if in_progress_id
        else '{ name: "In Progress", color: YELLOW, description: "Active work" }',
        '{ name: "Review", color: ORANGE, description: "Awaiting review" }',
        f'{{ id: "{done_id}", name: "Done", color: GREEN, description: "Complete" }}'
        if done_id
        else '{ name: "Done", color: GREEN, description: "Complete" }',
    ]
    mutation = f"""
    mutation {{
      updateProjectV2Field(input: {{
        fieldId: "{status_field["id"]}"
        singleSelectOptions: [{", ".join(options_parts)}]
      }}) {{
        projectV2Field {{
          ... on ProjectV2SingleSelectField {{
            name
            options {{ id name }}
          }}
        }}
      }}
    }}
    """
    run_gh(["api", "graphql", "-f", f"query={mutation}"], check=False)
    print("Configured project status columns")


def main() -> None:
    if not PLAN_PATH.exists():
        print(f"Missing plan: {PLAN_PATH}", file=sys.stderr)
        sys.exit(1)

    content = PLAN_PATH.read_text(encoding="utf-8")
    issues = parse_plan(content)
    print(f"Parsed {len(issues)} issues from PRODUCTION_PLAN.md")

    print("Creating labels...")
    ensure_labels()

    print("Creating milestones...")
    milestone_numbers = ensure_milestones()

    print("Creating issues...")
    issue_map = create_issues(issues, milestone_numbers)

    print("Adding dependency comments...")
    add_dependency_comments(issues, issue_map)

    print("Creating project board...")
    create_project()

    print("Configuring project status columns...")
    configure_project_status_columns()

    print(f"\nDone. Created/verified {len(issue_map)} issues in {REPO}")


if __name__ == "__main__":
    main()
