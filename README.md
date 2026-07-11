# Just Coffee

**Just Coffee** is a psychological point-and-click adventure about hyper-vigilance, street harassment, and the exhaustion of existing in public space — built in **Godot 4** with **GDScript**, fully bilingual **French / English**. The same day repeats across cycles; systems, not lectures, carry the themes. Design is locked in [`RULES.md`](RULES.md) (single source of truth).

> Production plan & issue backlog: [`tasks/PRODUCTION_PLAN.md`](tasks/PRODUCTION_PLAN.md)

## Current milestone

**Vertical Slice** — Cycle 0 + Cycle 1 + Café scene (~45–60 min demo).

## Requirements

- [Godot 4.7.stable](https://godotengine.org/) — pinned in [`.godot-version`](.godot-version) and [`docs/ENGINE.md`](docs/ENGINE.md)
- **Headphones strongly recommended** at launch — binaural spatial audio is core to the design ([`RULES.md` §10](RULES.md#10-audio-design))

## Rendering

The project uses **GL Compatibility** (`gl_compatibility` in `project.godot`). Just Coffee is 2D-heavy (illustrated backgrounds, CanvasItem shaders, no 3D pipeline); Compatibility trades some modern renderer features for broader GPU support on laptops and integrated graphics — appropriate for a narrative adventure with a wide playtest audience. Forward+ remains an option if a future milestone needs it; document any switch in `docs/ENGINE.md`.

## Open the project

1. Clone this repository.
2. Install [Godot 4.7.stable](https://godotengine.org/download) (match [`.godot-version`](.godot-version)).
3. In the Godot Project Manager, **Import** → select [`project.godot`](project.godot) at the repo root.
4. Run the project — **⌘ + B** on macOS, **F5** on Windows/Linux — the boot scene shows **Just Coffee — WIP** at 1920×1080.

## Export (playtest builds)

Desktop presets live in [`export_presets.cfg`](export_presets.cfg) (safe to commit — no secrets). Credentials belong in `.godot/export_credentials.cfg` (gitignored).

| Preset | Output path | Primary use |
|--------|-------------|-------------|
| **Windows Desktop** | `exports/windows/JustCoffee.exe` | Playtest distribution |
| **macOS** | `exports/macos/JustCoffee.zip` | Developer / macOS playtest |
| **Linux/X11** | `exports/linux/JustCoffee.x86_64` | Optional Linux playtest |

### One-time setup

1. **Export templates** — In the editor: **Editor → Manage Export Templates…** → install templates matching `4.7.stable`. Or download `Godot_v4.7-stable_export_templates.tpz` from [releases](https://github.com/godotengine/godot/releases/tag/4.7-stable) and extract into the Godot export-templates folder for your OS (see [Godot docs](https://docs.godotengine.org/en/stable/tutorials/export/exporting_projects.html)).
2. Create output folders if needed: `mkdir -p exports/{windows,macos,linux}`.

### CLI export (debug playtest)

From the repo root, with Godot on your `PATH` (or use the full path to the Godot binary):

```bash
# Windows (primary playtest)
godot --path . --headless --export-debug "Windows Desktop" exports/windows/JustCoffee.exe

# macOS
godot --path . --headless --export-debug "macOS" exports/macos/JustCoffee.zip

# Linux (optional)
godot --path . --headless --export-debug "Linux/X11" exports/linux/JustCoffee.x86_64
```

Use `--export-release` for release builds once the Vertical Slice is ready to ship externally.

Export smoke-test results: [`docs/QA/export-log.md`](docs/QA/export-log.md).

### Input placeholders

| Action | Default binding | Purpose |
|--------|-----------------|---------|
| `click` | Left mouse button | Hotspot / world interaction |
| `verb_select_prev` | Q | Cycle verb bar selection |
| `verb_select_next` | E | Cycle verb bar selection |
| `verb_confirm` | Enter | Confirm selected verb |

Full verb bar wiring lands in later UI issues ([#401+](https://github.com/LionGon/JustCoffee/issues)).

## Project status

Godot scaffold and folder tree per [`RULES.md` §13](RULES.md#13-technical-architecture--godot-4) are in place ([#3](https://github.com/LionGon/JustCoffee/issues/3)). Desktop export presets and engine pin ([#4](https://github.com/LionGon/JustCoffee/issues/4)). Six autoload stubs are registered; signal implementations follow in M1 core issues. Track work on the [GitHub Project board](https://github.com/users/LionGon/projects/8) (columns: Backlog → Ready → In Progress → Review → Done) and [open issues](https://github.com/LionGon/JustCoffee/issues). Unspecified design decisions go in [Discussions](https://github.com/LionGon/JustCoffee/discussions) or a design-gap issue ([`RULES.md` §16](RULES.md#16-locked-decisions--do-not-redesign)).

## For contributors & AI agents

1. Read [`RULES.md`](RULES.md) in full before any change.
2. Read [`CONTRIBUTING.md`](CONTRIBUTING.md).
3. Art contributors: read [`docs/VISUAL_STYLE.md`](docs/VISUAL_STYLE.md) ([#40](https://github.com/LionGon/JustCoffee/issues/40)).
4. Writers / Dialogic: read [`docs/DIALOGUE_CONVENTION.md`](docs/DIALOGUE_CONVENTION.md) ([#50](https://github.com/LionGon/JustCoffee/issues/50)).
5. Pick an issue from the backlog; respect dependency order in [`tasks/PRODUCTION_PLAN.md`](tasks/PRODUCTION_PLAN.md).
6. File bugs, features, or design gaps via the [issue templates](https://github.com/LionGon/JustCoffee/issues/new/choose) (blank issues disabled).

## Dev tools

- `scenes/ui/event_bus_test.tscn` — emit and receive all EventBus signals ([#5](https://github.com/LionGon/JustCoffee/issues/5))
- `scenes/ui/localization_test.tscn` — FR/EN toggle and string lookup ([#10](https://github.com/LionGon/JustCoffee/issues/10))
- `scenes/ui/saturation_test.tscn` — keyboard saturation debug ([#8](https://github.com/LionGon/JustCoffee/issues/8))
- `scenes/ui/inventory_test.tscn` — strategy inventory hooks ([#9](https://github.com/LionGon/JustCoffee/issues/9))
- `scenes/ui/verb_test.tscn` — verb cycle gating ([#11](https://github.com/LionGon/JustCoffee/issues/11))
- `scenes/debug/ambient_shader_demo.tscn` — rain, steam, lamp flicker shaders ([#23](https://github.com/LionGon/JustCoffee/issues/23))
- `scenes/debug/audio_bus_test.tscn` — bus layout + saturation muffling ([#33](https://github.com/LionGon/JustCoffee/issues/33))
- Audio bus layout: [`docs/AUDIO.md`](docs/AUDIO.md) ([#33](https://github.com/LionGon/JustCoffee/issues/33))
- Dialogue paths: [`docs/DIALOGUE_CONVENTION.md`](docs/DIALOGUE_CONVENTION.md) — 38 VS placeholder `.dtl` files ([#50](https://github.com/LionGon/JustCoffee/issues/50))
- `scenes/ui/core_test.tscn` — full autoload integration test ([#12](https://github.com/LionGon/JustCoffee/issues/12))

## License

TBD
