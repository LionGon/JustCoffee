#!/usr/bin/env python3
"""Roadmap schedule for Just Coffee GitHub Project #8.

Start anchor: 2026-07-01 (ISSUE-001).
Parallel tracks: core, shaders, audio, art, dialogic overlap where dependencies allow.
"""

from __future__ import annotations

# issue_number (GitHub #) -> (start, due) YYYY-MM-DD
SCHEDULE: dict[int, tuple[str, str]] = {
    # M0 — Repository & Godot Init
    1: ("2026-07-01", "2026-07-01"),  # ISSUE-001 repo init (done)
    2: ("2026-07-01", "2026-07-02"),  # ISSUE-002 templates (done)
    3: ("2026-07-02", "2026-07-04"),  # ISSUE-003 Godot scaffold
    4: ("2026-07-05", "2026-07-06"),  # ISSUE-004 export presets
    # M1 — Core Systems (106 parallel from day 7)
    5: ("2026-07-07", "2026-07-07"),  # ISSUE-101 EventBus
    6: ("2026-07-08", "2026-07-08"),  # ISSUE-102 GameFlags
    7: ("2026-07-09", "2026-07-10"),  # ISSUE-103 CycleStateManager
    8: ("2026-07-10", "2026-07-12"),  # ISSUE-104 SaturationManager
    9: ("2026-07-10", "2026-07-11"),  # ISSUE-105 InventoryManager (parallel 104)
    10: ("2026-07-07", "2026-07-09"),  # ISSUE-106 Localization (parallel 101–103)
    11: ("2026-07-11", "2026-07-13"),  # ISSUE-107 Verb system
    12: ("2026-07-14", "2026-07-14"),  # ISSUE-108 core integration test
    # M2 — Components (205 parallel with 201)
    13: ("2026-07-15", "2026-07-16"),  # ISSUE-201 InteractableArea
    14: ("2026-07-17", "2026-07-17"),  # ISSUE-202 VerbReceiver
    15: ("2026-07-17", "2026-07-20"),  # ISSUE-203 GazeVector
    16: ("2026-07-21", "2026-07-22"),  # ISSUE-204 NPC FSM
    17: ("2026-07-15", "2026-07-17"),  # ISSUE-205 movement (parallel 201)
    18: ("2026-07-23", "2026-07-24"),  # ISSUE-206 district template
    # M2 — Shaders (301–305 parallel with components; 304 waits for art rig)
    19: ("2026-07-13", "2026-07-14"),  # ISSUE-301 vignette (parallel post-104)
    20: ("2026-07-15", "2026-07-15"),  # ISSUE-302 desaturation
    21: ("2026-07-16", "2026-07-16"),  # ISSUE-303 camera drift
    22: ("2026-07-25", "2026-07-26"),  # ISSUE-304 NPC silhouette (needs 606)
    23: ("2026-07-10", "2026-07-13"),  # ISSUE-305 ambient shaders (parallel)
    24: ("2026-07-17", "2026-07-17"),  # ISSUE-306 reflection stub
    # M3 — UI
    25: ("2026-07-25", "2026-07-26"),  # ISSUE-401 verb bar
    26: ("2026-07-27", "2026-07-27"),  # ISSUE-402 inventory bar
    27: ("2026-07-27", "2026-07-28"),  # ISSUE-403 location indicator
    28: ("2026-07-25", "2026-07-27"),  # ISSUE-404 inner monologue box
    29: ("2026-07-28", "2026-07-29"),  # ISSUE-405 outfit lying UI
    30: ("2026-07-31", "2026-08-01"),  # ISSUE-406 pause menu
    31: ("2026-07-28", "2026-07-30"),  # ISSUE-407 save system
    32: ("2026-08-02", "2026-08-02"),  # ISSUE-408 HUD composition
    # M4 — Audio (501/505 early parallel with core)
    33: ("2026-07-10", "2026-07-12"),  # ISSUE-501 audio buses
    34: ("2026-07-23", "2026-07-24"),  # ISSUE-502 spatial audio
    35: ("2026-07-14", "2026-07-20"),  # ISSUE-503 piano 8-bar (human)
    36: ("2026-07-21", "2026-07-21"),  # ISSUE-504 piano placeholders
    37: ("2026-07-15", "2026-07-19"),  # ISSUE-505 city ambience
    38: ("2026-07-21", "2026-07-22"),  # ISSUE-506 Elena stinger
    39: ("2026-07-25", "2026-07-27"),  # ISSUE-507 café SFX
    # M5 — Art
    40: ("2026-07-07", "2026-07-08"),  # ISSUE-601 style guide
    41: ("2026-07-11", "2026-07-16"),  # ISSUE-602 apartment C0
    42: ("2026-07-21", "2026-07-22"),  # ISSUE-603 apartment C1 decay
    43: ("2026-07-13", "2026-07-20"),  # ISSUE-604 district backgrounds
    44: ("2026-07-21", "2026-07-26"),  # ISSUE-605 café interior
    45: ("2026-07-17", "2026-07-22"),  # ISSUE-606 protagonist rig
    46: ("2026-07-23", "2026-07-28"),  # ISSUE-607 NPC rigs
    47: ("2026-07-24", "2026-07-25"),  # ISSUE-608 bus shelter
    48: ("2026-07-27", "2026-07-29"),  # ISSUE-609 reflection anomaly art
    # M6 — Dialogic & narrative pipeline
    49: ("2026-07-08", "2026-07-09"),  # ISSUE-701 Dialogic install
    50: ("2026-07-10", "2026-07-10"),  # ISSUE-702 dialogue naming
    51: ("2026-07-28", "2026-07-30"),  # ISSUE-703 monologue separation
    52: ("2026-07-31", "2026-08-01"),  # ISSUE-704 writing guide
    53: ("2026-08-02", "2026-08-10"),  # ISSUE-705 Cycle 0 scripts
    54: ("2026-08-11", "2026-08-19"),  # ISSUE-706 Cycle 0 implementation
    55: ("2026-08-20", "2026-08-22"),  # ISSUE-707 Cycle 1 opening
    56: ("2026-08-02", "2026-08-02"),  # ISSUE-708 pause flavor text
    57: ("2026-08-03", "2026-08-03"),  # ISSUE-709 gaze strings café
    # M8 — Cycle 1 & café (902 parallel 901; 908 parallel café build)
    58: ("2026-08-23", "2026-08-27"),  # ISSUE-901 C1 district traversal
    59: ("2026-08-23", "2026-08-28"),  # ISSUE-902 C1 narrative scripts
    60: ("2026-08-29", "2026-09-02"),  # ISSUE-903 café environment
    61: ("2026-09-03", "2026-09-05"),  # ISSUE-904 café beats 1–5
    62: ("2026-09-06", "2026-09-10"),  # ISSUE-905 café beats 6–10 LOCKED
    63: ("2026-09-11", "2026-09-12"),  # ISSUE-906 dialogue trees B & C
    64: ("2026-09-13", "2026-09-14"),  # ISSUE-907 return home
    65: ("2026-09-03", "2026-09-05"),  # ISSUE-908 Dorian beats (parallel 904)
    66: ("2026-07-07", "2026-08-15"),  # ISSUE-909 protagonist name (ongoing)
    67: ("2026-09-15", "2026-09-16"),  # ISSUE-910 main menu flow
    68: ("2026-09-17", "2026-09-17"),  # ISSUE-911 strategy list end screen
    # M9 — QA & ship (1003 parallel mid-QA)
    69: ("2026-09-18", "2026-09-23"),  # ISSUE-1001 QA playthrough script
    70: ("2026-09-24", "2026-09-26"),  # ISSUE-1002 bilingual audit
    71: ("2026-09-20", "2026-09-21"),  # ISSUE-1003 performance pass
    72: ("2026-09-27", "2026-09-28"),  # ISSUE-1004 export VS build
    73: ("2026-09-29", "2026-09-29"),  # ISSUE-1005 post-VS epics
}

PROJECT_NUMBER = 8
PROJECT_ID = "PVT_kwHOA1sLDM4Bb32O"
OWNER = "LionGon"
REPO = "LionGon/JustCoffee"
