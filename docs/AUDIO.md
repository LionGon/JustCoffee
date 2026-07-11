# Audio design — Just Coffee

> **Source of truth:** [`RULES.md`](../RULES.md) §10  
> **Issue:** [#33](https://github.com/LionGon/JustCoffee/issues/33) / ISSUE-501

## Bus layout

Defined in [`default_bus_layout.tres`](../default_bus_layout.tres) and referenced from `project.godot`.

| Bus | Role | Routing |
|---|---|---|
| **Master** | Final mix | — |
| **Ambience** | City stereo bed, slightly behind player | → Master |
| **Music** | Piano motif (café theme Cycle 1 only in VS) | → Master |
| **NPC_Voice** | Hostile/benevolent dialogue | → Master |
| **Inner_Monologue** | Dead center, dry, intimate — no reverb | → Master |
| **UI** | Save silence, minimal chrome | → Master (−6 dB) |

## Saturation muffling

[`scripts/systems/audio_saturation_controller.gd`](../scripts/systems/audio_saturation_controller.gd) listens to `EventBus.saturation_changed` and drives a **low-pass filter** on the **Ambience** bus:

- `saturation 0.0` → cutoff ~20.5 kHz (clear city)
- `saturation 1.0` → cutoff ~650 Hz (muffled, high-frequency loss per §6.1)

Inner monologue bus stays dry and centered; saturation does not add reverb to hostile dialogue gaps (those are per-line mix specs in ISSUE-503).

## Spatial rules (stub — ISSUE-502)

| Source | Pan / depth |
|---|---|
| Hostile NPC voice | Behind or beside — never frontal |
| Benevolent NPC | Front, medium distance |
| City ambience | Stereo, slightly behind player |
| Inner monologue | Center, dry |

## Assigning streams in scenes

```gdscript
# Example — ambience loop on district enter
$AmbiencePlayer.bus = "Ambience"

# Inner monologue one-shot
$MonologuePlayer.bus = "Inner_Monologue"
```

## Verification

1. Open project in Godot 4.7+ → **Project → Project Settings → Audio** shows six buses.
2. Run `scenes/debug/audio_bus_test.tscn` (ISSUE-501) — noise on Ambience bus; ↑/↓ saturation changes muffling audibly.
3. Confirm no video files are used for ambience (ISSUE-305).
