# Contributing to Just Coffee

## Before you write code or content

1. Read [`RULES.md`](RULES.md) — the entire file. It is locked design.
2. Check [`tasks/PRODUCTION_PLAN.md`](tasks/PRODUCTION_PLAN.md) for task order and dependencies.
3. If something is **not specified** in RULES.md, open a **Design gap** issue. Do not invent.

## Hard rules

| Rule | Reference |
|---|---|
| GDScript only — no C# | RULES.md §0 |
| Static typing on all variables and functions | RULES.md §13 |
| EventBus for cross-system signals — no direct node coupling between systems | RULES.md §13 |
| Never expose Saturation as UI (bar, number, icon) | RULES.md §6.1, §11 |
| Never use standard P&C verbs (Look At, Use, Talk To, Pick Up) | RULES.md §6.4 |
| Use the 10 custom verbs only (OBSERVER, ABORDER, …) | RULES.md §6.4 |
| Outfit / discretion UI must not affect harassment mechanics | RULES.md §6.3 |
| Do not redesign locked scenes (Cycle 1 Café, Elena gaze, Marc apology line) | RULES.md §7, §5 |
| Inner monologue: logistics & calculations — never direct emotion | RULES.md §3 |
| Hostile NPCs: deniable, never cartoon-villain obvious | RULES.md §16 |
| Marionette Skeleton2D rigs — no sprite-sheet walk cycles | RULES.md §9 |
| Comments in code: English. Dialogue: FR primary, EN adapted | RULES.md §12, §16 |
| Permitted UI lies are listed in RULES.md §11 only | RULES.md §11 |

## Pull requests

Use the PR template checklist. Narrative PRs must pass [`docs/WRITING_GUIDE.md`](docs/WRITING_GUIDE.md) when that file exists.

## Issue templates

Use the matching GitHub template when opening an issue:

| Template | When to use |
|---|---|
| **Bug report** | Something broke — include cycle, district, language (FR/EN), and repro steps |
| **Feature request** | New functionality that aligns with RULES.md |
| **Design gap** | Decision not in RULES.md — propose options only; **no implementation until confirmed** |

Blank issues are disabled. Unspecified design goes through **Design gap**, not a feature request.
