# Engine pin — Just Coffee

Single source of truth for the Godot editor and export template version used for the Vertical Slice.

| Field | Value |
|-------|-------|
| **Engine** | Godot 4 |
| **Pinned version** | `4.7.stable` |
| **Rendering** | GL Compatibility (`gl_compatibility` in `project.godot`) |
| **VRAM import** | `rendering/textures/vram_compression/import_etc2_astc=true` (required for universal macOS export) |
| **Export templates** | Must match `4.7.stable` (see [README](../README.md#export-playtest-builds)) |

## Why pin?

Playtest builds must be reproducible. Mismatched editor vs export-template versions cause subtle export failures or runtime bugs. Contributors and CI should use the same minor release as recorded in [`.godot-version`](../.godot-version).

## Upgrading

1. Install the new Godot editor and matching export templates.
2. Open the project once in the editor; resolve any migration prompts.
3. Update `.godot-version`, this file, and `README.md`.
4. Re-export all desktop presets and smoke-test boot scene on each target OS.
5. Note the change in the PR and bump the pin in `tasks/PRODUCTION_PLAN.md` if the plan references a specific version.
