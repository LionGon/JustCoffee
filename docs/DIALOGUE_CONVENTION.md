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

**Decision (ISSUE-909 / #66, 2026-07-12):** **Dorian** — locked by maintainer.

| Field | Value |
|---|---|
| **FR / EN** | Dorian (same in both locales) |
| **Etymology / intent** | Echoes the locked §4 mechanic *Dorian Superposition* (portrait vs. appearance) — deliberate; not spoken in dialogue |
| **`RULES.md`** | §3 updated — **Dorian** |
| **Dialogue files** | Use `Dorian` in NPC-facing lines; inner monologue stays nameless |

Writers: replace any `[PROTAGONIST]` placeholder in `data/dialogues/` with `Dorian` when authoring NPC lines. No global replace needed yet — VS `.dtl` files are still empty placeholders.

### Inner monologue — name usage

Per RULES.md §3, inner monologue timelines (`*_monologue.dtl`) **never** use the protagonist's name when it would break intimacy or feel awkward.

| Channel | Name usage |
|---|---|
| NPC dialogue | `Dorian` when an NPC addresses or refers to him by name |
| Inner monologue | First-person, nameless: *"400 mètres. 18 h 43."* — not *"Dorian compte 400 mètres."* |
| Rare exception | Only if a specific narrative beat requires it — human writer approval |

Voice expresses logistics, rationalizations, and calculations — not direct emotion. Naming the protagonist in inner monologue is almost always wrong.
