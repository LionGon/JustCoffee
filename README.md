# Just Coffee

**Just Coffee** is a psychological point-and-click adventure about hyper-vigilance, street harassment, and the exhaustion of existing in public space — built in **Godot 4** with **GDScript**, fully bilingual **French / English**. The same day repeats across cycles; systems, not lectures, carry the themes. Design is locked in [`RULES.md`](RULES.md) (single source of truth).

> Production plan & issue backlog: [`tasks/PRODUCTION_PLAN.md`](tasks/PRODUCTION_PLAN.md)

## Current milestone

**Vertical Slice** — Cycle 0 + Cycle 1 + Café scene (~45–60 min demo).

## Requirements

- [Godot 4.3+](https://godotengine.org/) — **pin: 4.3.x** until `docs/ENGINE.md` records the exact editor version used for the Vertical Slice
- **Headphones strongly recommended** at launch — binaural spatial audio is core to the design ([`RULES.md` §10](RULES.md#10-audio-design))

## Rendering

The project uses **GL Compatibility** (`gl_compatibility` in `project.godot`). Just Coffee is 2D-heavy (illustrated backgrounds, CanvasItem shaders, no 3D pipeline); Compatibility trades some modern renderer features for broader GPU support on laptops and integrated graphics — appropriate for a narrative adventure with a wide playtest audience. Forward+ remains an option if a future milestone needs it; document any switch in `docs/ENGINE.md`.

## Open the project

1. Clone this repository.
2. Install [Godot 4.3+](https://godotengine.org/download).
3. In the Godot Project Manager, **Import** → select [`project.godot`](project.godot) at the repo root.
4. Run the project — **⌘ + B** on macOS, **F5** on Windows/Linux — the boot scene shows **Just Coffee — WIP** at 1920×1080.

### Input placeholders

| Action | Default binding | Purpose |
|--------|-----------------|---------|
| `click` | Left mouse button | Hotspot / world interaction |
| `verb_select_prev` | Q | Cycle verb bar selection |
| `verb_select_next` | E | Cycle verb bar selection |
| `verb_confirm` | Enter | Confirm selected verb |

Full verb bar wiring lands in later UI issues ([#401+](https://github.com/LionGon/JustCoffee/issues)).

## Project status

Godot scaffold and folder tree per [`RULES.md` §13](RULES.md#13-technical-architecture--godot-4) are in place ([#3](https://github.com/LionGon/JustCoffee/issues/3)). Six autoload stubs are registered; signal implementations follow in M1 core issues. Track work on the [GitHub Project board](https://github.com/users/LionGon/projects/8) (columns: Backlog → Ready → In Progress → Review → Done) and [open issues](https://github.com/LionGon/JustCoffee/issues). Unspecified design decisions go in [Discussions](https://github.com/LionGon/JustCoffee/discussions) or a design-gap issue ([`RULES.md` §16](RULES.md#16-locked-decisions--do-not-redesign)).

## For contributors & AI agents

1. Read [`RULES.md`](RULES.md) in full before any change.
2. Read [`CONTRIBUTING.md`](CONTRIBUTING.md).
3. Pick an issue from the backlog; respect dependency order in [`tasks/PRODUCTION_PLAN.md`](tasks/PRODUCTION_PLAN.md).
4. File bugs, features, or design gaps via the [issue templates](https://github.com/LionGon/JustCoffee/issues/new/choose) (blank issues disabled).

## Dev tools (when available)

- `scenes/ui/core_test.tscn` — autoload / EventBus integration test scene

## License

TBD
