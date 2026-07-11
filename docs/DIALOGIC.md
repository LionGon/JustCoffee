# Dialogic 2 — Just Coffee

Dialogue system for all in-game text (RULES.md §13). Non-dialogue UI strings stay in `data/localization/*.csv` via `LocalizationManager`.

## Version

| Component | Pin |
|-----------|-----|
| Godot | `4.7.stable` (see `.godot-version`) |
| Dialogic | `main` branch from [dialogic-godot/dialogic](https://github.com/dialogic-godot/dialogic) — Alpha 20+ (Godot 4.4+) |

Install or update:

```bash
git clone --depth 1 https://github.com/dialogic-godot/dialogic.git /tmp/dialogic-src
rm -rf addons/dialogic
mv /tmp/dialogic-src/addons/dialogic addons/dialogic
rm -rf /tmp/dialogic-src
```

Open the project once in Godot 4.7 so the plugin imports assets. **Project → Project Settings → Plugins → Dialogic** must stay enabled.

The input action `dialogic_default_action` (Enter, click, Space, X, gamepad A) is committed in `project.godot` so dialogue advance works at runtime — not only when the editor plugin runs.

## Folder layout

```
data/dialogues/
├── fr/
│   └── cycle_[n]/
│       └── [district]_[scene].dtl
└── en/
    └── cycle_[n]/
        └── [district]_[scene].dtl
```

Inner monologue timelines use the `_monologue` suffix (ISSUE-702). Sample pair for acceptance:

- `fr/cycle_0/sample_greeting.dtl`
- `en/cycle_0/sample_greeting.dtl`

## Locale pairing

FR and EN are **separate timeline files**, not a single translated resource. `DialogicBridge.get_timeline_path(relative_path)` prefixes the active `LocalizationManager` locale:

```gdscript
var path := DialogicBridge.get_timeline_path("cycle_0/threshold_apartment.dtl")
Dialogic.start(path)
```

Toggle locale in the pause menu or dev scenes via `LocalizationManager.set_locale("fr"|"en")`.

## Variable sync

`DialogicBridge` (autoload) mirrors game state into Dialogic variables on boot and whenever cycle/district changes:

| Dialogic variable | Source |
|-------------------|--------|
| `current_cycle` | `CycleStateManager.current_cycle` |
| `current_district` | `CycleStateManager.current_district` |
| `district_index` | `CycleStateManager.district_index` |
| `is_cafe_scene` | `CycleStateManager.is_cafe_scene` |
| `elena_gaze_complete` | `GameFlags` |
| `cafe_spill_occurred` | `GameFlags` |
| `marc_apologized` | `GameFlags` |
| `inner_monologue_silent` | `GameFlags` |
| `selected_outfit_id` | `GameFlags` |

Use `{variable_name}` in timeline text or `[if]` conditions. Call `DialogicBridge.sync_all()` after changing flags outside the normal EventBus flow.

## Dev test scene

1. Set main scene to `scenes/ui/dialogic_test.tscn` (or run from editor).
2. **Toggle FR / EN** — path switches between locale folders.
3. **Run sample_greeting.dtl** — Dialogic layout appears with synced cycle/district variables.

Related dev scenes: `game_flags_test.tscn`, `cycle_state_test.tscn`.

## Inner monologue vs NPC dialogue

- NPC lines: standard Dialogic text events with character resources (added in ISSUE-703+).
- Inner monologue: separate timelines (`*_monologue.dtl`) and layout — never mixed in the same text box (RULES.md §13).

## Protagonist placeholder

Dialogue files use `[PROTAGONIST]` until [design gap #81](https://github.com/LionGon/JustCoffee/issues/81) / ISSUE-909 is resolved.
