#!/usr/bin/env python3
"""Executor and tool assignments per GitHub issue (#1–#73).

Primary executor:
  - cursor        → Cursor agent can own end-to-end (human may review)
  - human         → Human only (creative, approval, composition)
  - cursor+human  → Cursor implements/drafts; human must edit, approve, or polish

Tools (when work happens outside Cursor):
  - godot, dialogic, daw, art, github, audacity
"""

from __future__ import annotations

from typing import NamedTuple


class ExecutorSpec(NamedTuple):
    primary: str  # cursor | human | cursor+human
    tools: tuple[str, ...]
    notes: str


# GitHub issue number → spec
EXECUTOR_MAP: dict[int, ExecutorSpec] = {
    # M0
    1: ExecutorSpec("cursor", ("github",), "Repo, project board, milestones — largely done."),
    2: ExecutorSpec("cursor", ("github",), "Issue/PR templates and CONTRIBUTING.md."),
    3: ExecutorSpec("cursor", ("godot",), "Scaffold in Cursor; open and run in Godot 4 to verify."),
    4: ExecutorSpec("cursor", ("godot",), "Export presets; validate with Godot export dialog."),
    # M1 Core
    5: ExecutorSpec("cursor", ("godot",), "GDScript autoload; test in Godot core_test scene."),
    6: ExecutorSpec("cursor", ("godot",), "GDScript autoload."),
    7: ExecutorSpec("cursor", ("godot",), "GDScript autoload."),
    8: ExecutorSpec("cursor", ("godot",), "GDScript + shader hooks; verify visually in Godot."),
    9: ExecutorSpec("cursor", ("godot",), "GDScript inventory system."),
    10: ExecutorSpec("cursor", ("godot",), "LocalizationManager + CSV/JSON string tables."),
    11: ExecutorSpec("cursor", ("godot",), "Verb enum and cycle gating."),
    12: ExecutorSpec("cursor", ("godot",), "Debug integration scene in Godot."),
    # M2 Components
    13: ExecutorSpec("cursor", ("godot",), "InteractableArea component."),
    14: ExecutorSpec("cursor", ("godot",), "VerbReceiver + Resource definitions."),
    15: ExecutorSpec("cursor", ("godot",), "GazeVector component; hedged text keys."),
    16: ExecutorSpec("cursor", ("godot",), "NPC FSM component."),
    17: ExecutorSpec("cursor+human", ("godot",), "Cursor wires movement; human tunes walk feel (marionette stiffness)."),
    18: ExecutorSpec("cursor", ("godot",), "District scene template .tscn."),
    # M2 Shaders
    19: ExecutorSpec("cursor", ("godot",), "CanvasItemShader vignette; preview in Godot."),
    20: ExecutorSpec("cursor", ("godot",), "Desaturation shader."),
    21: ExecutorSpec("cursor", ("godot",), "Camera drift shader."),
    22: ExecutorSpec("cursor+human", ("godot",), "Cursor toggles silhouette layers; human validates look with art rigs."),
    23: ExecutorSpec("cursor", ("godot",), "Rain, steam, lamp flicker shaders."),
    24: ExecutorSpec("cursor", ("godot",), "Reflection mode shader stub."),
    # M3 UI
    25: ExecutorSpec("cursor+human", ("godot",), "Cursor builds verb bar; human approves layout and FR/EN labels."),
    26: ExecutorSpec("cursor", ("godot",), "Inventory bar UI."),
    27: ExecutorSpec("cursor", ("godot",), "Location + cycle indicator."),
    28: ExecutorSpec("cursor+human", ("godot",), "Cursor builds monologue box; human validates tone separation from NPC dialogue."),
    29: ExecutorSpec("cursor+human", ("godot",), "Cursor implements screen; human confirms lying copy matches RULES.md exactly."),
    30: ExecutorSpec("cursor+human", ("godot",), "Cursor builds pause UI; human writes suspended-thoughts flavor."),
    31: ExecutorSpec("cursor", ("godot",), "Save system — Demain/Tomorrow, silence on save."),
    32: ExecutorSpec("cursor", ("godot",), "HUD composition scene."),
    # M4 Audio
    33: ExecutorSpec("cursor+human", ("godot",), "Cursor creates bus layout in Godot; human approves mix hierarchy."),
    34: ExecutorSpec("cursor", ("godot",), "Spatial panning rules in GDScript."),
    35: ExecutorSpec("human", ("daw",), "Composer records 8-bar piano in a DAW (Logic, Ableton, Reaper, etc.); export .ogg."),
    36: ExecutorSpec("human", ("daw",), "Composer brief / placeholder stems — not used in VS gameplay."),
    37: ExecutorSpec("human", ("daw",), "Human composes city breathing ambience in DAW; Cursor imports to Godot."),
    38: ExecutorSpec("human", ("daw",), "Three-note Elena stinger in DAW."),
    39: ExecutorSpec("cursor+human", ("godot", "audacity"), "Human records/edits spill SFX (Audacity or DAW); Cursor integrates timing (1.2s gap)."),
    # M5 Art
    40: ExecutorSpec("cursor+human", (), "Cursor drafts docs/VISUAL_STYLE.md; human approves final art direction."),
    41: ExecutorSpec("human", ("art",), "Illustrated background in Krita, Photoshop, or Procreate; import to Godot."),
    42: ExecutorSpec("human", ("art",), "Cycle 1 apartment decay variants."),
    43: ExecutorSpec("human", ("art",), "Artery, Corridor, Square backgrounds."),
    44: ExecutorSpec("human", ("art",), "Café interior — reference assets/cafe-scene.png."),
    45: ExecutorSpec("cursor+human", ("godot", "art"), "Human draws cut-out limbs; Cursor assembles Skeleton2D rig in Godot."),
    46: ExecutorSpec("cursor+human", ("godot", "art"), "Human draws NPC parts; Cursor rigs Marc, Thomas, Kevin, Elena in Godot."),
    47: ExecutorSpec("human", ("art",), "Bus shelter micro-sanctuary art."),
    48: ExecutorSpec("cursor+human", ("godot", "art"), "Human paints window reflection; Cursor hooks anomaly in scene."),
    # M6 Narrative
    49: ExecutorSpec("cursor", ("godot", "dialogic"), "Install Dialogic 2 addon via Godot Asset Library or git submodule."),
    50: ExecutorSpec("cursor", ("dialogic",), "Folder convention and placeholder .dtl files."),
    51: ExecutorSpec("cursor+human", ("godot", "dialogic"), "Cursor separates tracks; human confirms inner voice never mixes NPC box."),
    52: ExecutorSpec("cursor+human", (), "Cursor drafts WRITING_GUIDE.md; human locks voice rules."),
    53: ExecutorSpec("cursor+human", ("dialogic",), "Cursor drafts FR timelines; human adapts EN and edits tone."),
    54: ExecutorSpec("cursor+human", ("godot", "dialogic"), "Cursor assembles Cycle 0 scenes; human playtests pacing and Elena beat."),
    55: ExecutorSpec("cursor+human", ("godot", "dialogic"), "Cycle 1 apartment opening; human validates sawtooth feel."),
    56: ExecutorSpec("cursor+human", ("dialogic",), "Pause menu flavor strings FR/EN."),
    57: ExecutorSpec("cursor+human", ("dialogic",), "Locked gaze strings Thomas/Kevin — human verifies hedged tone."),
    # M8 Cycle 1
    58: ExecutorSpec("cursor+human", ("godot", "dialogic"), "District traversal; human playtests tension curve."),
    59: ExecutorSpec("cursor+human", ("dialogic",), "Cycle 1 exterior dialogue; human edits FR/EN."),
    60: ExecutorSpec("cursor+human", ("godot",), "Café scene assembly; human validates staging vs reference art."),
    61: ExecutorSpec("cursor+human", ("godot", "dialogic"), "Café beats 1–5 implementation."),
    62: ExecutorSpec("cursor+human", ("godot", "dialogic"), "LOCKED beats 6–10 — human must sign off Marc apology line and 1.2s gap."),
    63: ExecutorSpec("cursor+human", ("dialogic",), "Dialogue trees B & C; human reviews internalization branches."),
    64: ExecutorSpec("cursor+human", ("godot",), "Return home beat; human checks brief release."),
    65: ExecutorSpec("cursor+human", ("godot", "dialogic"), "Subtle Dorian beats; human ensures ambiguity preserved."),
    66: ExecutorSpec("human", (), "Creative decision only — protagonist name. No tool."),
    67: ExecutorSpec("cursor+human", ("godot",), "Main menu flow; human approves UX."),
    68: ExecutorSpec("cursor", ("godot",), "Optional end-screen strategy list UI."),
    # M9 Ship
    69: ExecutorSpec("cursor+human", ("godot",), "Cursor writes QA doc; human runs two full playthroughs (FR + EN)."),
    70: ExecutorSpec("cursor+human", ("dialogic",), "Cursor scans placeholders; human reads all locked lines."),
    71: ExecutorSpec("cursor", ("godot",), "Godot profiler / performance pass."),
    72: ExecutorSpec("cursor+human", ("godot",), "Cursor configures export; human playtests on clean machine."),
    73: ExecutorSpec("cursor", ("github",), "Create post-VS epic issues on GitHub."),
}

EXECUTOR_LABELS: dict[str, str] = {
    "cursor": "executor:cursor",
    "human": "executor:human",
    "cursor+human": "executor:cursor+human",
}

TOOL_LABELS: dict[str, str] = {
    "godot": "tool:godot",
    "dialogic": "tool:dialogic",
    "daw": "tool:daw",
    "art": "tool:art",
    "github": "tool:github",
    "audacity": "tool:audacity",
}

TOOL_DISPLAY: dict[str, str] = {
    "godot": "Godot 4.x editor",
    "dialogic": "Dialogic 2 (Godot addon)",
    "daw": "DAW — Logic, Ableton, Reaper, FL Studio, etc.",
    "art": "Art suite — Krita, Photoshop, Procreate, Aseprite, etc.",
    "github": "GitHub (web or `gh` CLI)",
    "audacity": "Audacity or DAW (SFX editing)",
}


def executor_labels_for(spec: ExecutorSpec) -> list[str]:
    labels = [EXECUTOR_LABELS[spec.primary]]
    for tool in spec.tools:
        labels.append(TOOL_LABELS[tool])
    return labels


def executor_section(spec: ExecutorSpec) -> str:
    primary_display = {
        "cursor": "**Cursor** — agent can implement autonomously",
        "human": "**Human** — not delegable to Cursor",
        "cursor+human": "**Cursor + Human** — Cursor drafts/implements; human reviews, edits, or approves",
    }[spec.primary]

    if spec.tools:
        tools_display = ", ".join(TOOL_DISPLAY[t] for t in spec.tools)
    else:
        tools_display = "None (documentation / creative decision in Cursor or offline)"

    return (
        "## Executor & tools\n\n"
        "| | |\n|---|---|\n"
        f"| **Who** | {primary_display} |\n"
        f"| **External tools** | {tools_display} |\n"
        f"| **Notes** | {spec.notes} |\n"
    )
