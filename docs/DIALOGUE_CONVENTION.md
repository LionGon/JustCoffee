# Dialogue file naming convention — Just Coffee

> **Issue:** [#50](https://github.com/LionGon/JustCoffee/issues/50) / ISSUE-702  
> **Source of truth:** [`RULES.md`](../RULES.md) §13

## Path pattern

```
data/dialogues/[fr|en]/cycle_[n]/[district]_[scene].dtl
```

| Segment | Rule |
|---|---|
| `fr` / `en` | Locale — French primary, English adapted (§12) |
| `cycle_[n]` | Narrative cycle `0`–`4` (epilogue uses separate pipeline later) |
| `[district]_[scene]` | Lowercase snake_case; district id from §2 (`threshold`, `artery`, `corridor`, `square`, `cafe`) |

## Inner monologue

Timelines that carry **inner voice only** (never mixed with NPC speech in the same layout — ISSUE-703) use the `_monologue` suffix:

```
threshold_apartment_monologue.dtl
cafe_main_monologue.dtl
```

## Examples

| File | Purpose |
|---|---|
| `fr/cycle_0/threshold_apartment.dtl` | Cycle 0 apartment rituals |
| `fr/cycle_0/elena_beat.dtl` | Locked Elena gaze beat (minimal/no player lines) |
| `fr/cycle_1/cafe_main.dtl` | Locked café scene NPC dialogue (§7) |
| `en/cycle_1/cafe_main.dtl` | English parity for café |
| `fr/cycle_1/cafe_main_monologue.dtl` | Café inner monologue channel |

## Vertical Slice placeholders

Empty placeholder `.dtl` files exist for every VS scene listed in [`tasks/PRODUCTION_PLAN.md`](../tasks/PRODUCTION_PLAN.md) ISSUE-705 / ISSUE-901. Writers replace `# PLACEHOLDER` headers with Dialogic 2 timelines.

## Dialogic locale sync

When Dialogic is integrated (ISSUE-701), load timelines from:

```gdscript
var locale := LocalizationManager.get_dialogic_locale()
var path := "res://data/dialogues/%s/cycle_%d/%s.dtl" % [locale, cycle, scene_id]
```

## Protagonist name

Dialogue files use `[PROTAGONIST]` until ISSUE-909 is decided. Do not replace in `RULES.md` until human updates the master doc.
