# Just Coffee

**Just Coffee** is a psychological point-and-click adventure about hyper-vigilance, street harassment, and the exhaustion of existing in public space — built in **Godot 4** with **GDScript**, fully bilingual **French / English**. The same day repeats across cycles; systems, not lectures, carry the themes. Design is locked in [`RULES.md`](RULES.md) (single source of truth).

> Production plan & issue backlog: [`tasks/PRODUCTION_PLAN.md`](tasks/PRODUCTION_PLAN.md)

## Current milestone

**Vertical Slice** — Cycle 0 + Cycle 1 + Café scene (~45–60 min demo).

## Requirements

- [Godot 4.3+](https://godotengine.org/) — **pin: 4.3.x** until `docs/ENGINE.md` records the exact editor version used for the Vertical Slice
- **Headphones strongly recommended** at launch — binaural spatial audio is core to the design ([`RULES.md` §10](RULES.md#10-audio-design))

## Open the project

1. Clone this repository.
2. Install [Godot 4.3+](https://godotengine.org/download).
3. In the Godot Project Manager, **Import** → select [`project.godot`](project.godot) at the repo root (created in [#3](https://github.com/LionGon/JustCoffee/issues/3)).
4. Press **F5** to run once the scaffold lands.

## Project status

Repository and GitHub board are set up; Godot scaffold is next ([#3](https://github.com/LionGon/JustCoffee/issues/3)). Track work on the [GitHub Project board](https://github.com/users/LionGon/projects/8) (columns: Backlog → Ready → In Progress → Review → Done) and [open issues](https://github.com/LionGon/JustCoffee/issues). Unspecified design decisions go in [Discussions](https://github.com/LionGon/JustCoffee/discussions) or a design-gap issue ([`RULES.md` §16](RULES.md#16-locked-decisions--do-not-redesign)).

## For contributors & AI agents

1. Read [`RULES.md`](RULES.md) in full before any change.
2. Read [`CONTRIBUTING.md`](CONTRIBUTING.md).
3. Pick an issue from the backlog; respect dependency order in [`tasks/PRODUCTION_PLAN.md`](tasks/PRODUCTION_PLAN.md).
4. File bugs, features, or design gaps via the [issue templates](https://github.com/LionGon/JustCoffee/issues/new/choose) (blank issues disabled).

## Dev tools (when available)

- `scenes/ui/core_test.tscn` — autoload / EventBus integration test scene

## License

TBD
