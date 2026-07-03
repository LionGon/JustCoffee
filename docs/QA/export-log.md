# Export QA log

Smoke-test record for desktop export presets ([ISSUE-004](https://github.com/LionGon/JustCoffee/issues/4)).

## 2026-07-03 — Initial preset validation

| Field | Value |
|-------|-------|
| **Engine** | Godot `4.7.stable.official.5b4e0cb0f` |
| **Host** | macOS (Apple Silicon), export via headless CLI |
| **Preset** | `macOS` (debug) |
| **Output** | `exports/macos/JustCoffee.zip` (~61 MB) |
| **Result** | ✅ Success — boot scene packaged, no export errors |

### Command used

```bash
godot --path . --headless --export-debug "macOS" exports/macos/JustCoffee.zip
```

### Secondary check

```bash
godot --path . --headless --export-debug "Windows Desktop" exports/windows/JustCoffee.exe
```

Result: ✅ Success (cross-compile from macOS).

### Notes

- Export templates for `4.7.stable` must be installed (Editor → Manage Export Templates, or download from [Godot releases](https://github.com/godotengine/godot/releases/tag/4.7-stable)).
- Project setting `rendering/textures/vram_compression/import_etc2_astc` is enabled for universal macOS builds.
- `exports/` output is gitignored; artifacts are local playtest builds only.
