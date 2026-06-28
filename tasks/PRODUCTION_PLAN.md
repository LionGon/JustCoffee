# Just Coffee — Production Plan

> **Purpose:** Ordered, detailed task list for building the Vertical Slice milestone  
> **Source of truth:** [`RULES.md`](../RULES.md) — every task defers to it  
> **Current milestone:** Vertical Slice = **Cycle 0 + Cycle 1 + Café scene** (~45–60 min demo)  
> **Engine:** Godot 4.x · GDScript only · Bilingual FR/EN

---

## How to Use This Document

### For a new agent setting up GitHub

1. Create a GitHub repository (private or public per developer preference).
2. Create **Milestones** from the table below (in order).
3. Create **Labels** from the label table below.
4. Create one GitHub Issue per task (`ISSUE-001` … `ISSUE-048`).
   - Copy the **Issue Title**, **Body** (Objective + Requirements + Acceptance Criteria), **Labels**, **Milestone**, and link **Dependencies** in the issue body or as blocked-by relationships.
5. Add all issues to a GitHub Project board with columns: `Backlog → Ready → In Progress → Review → Done`.
6. Respect **dependency order** — do not start a task until its dependencies are `Done`.

### Task ID convention

| Prefix | Meaning |
|---|---|
| `ISSUE-0xx` | Repository & project infrastructure |
| `ISSUE-1xx` | Godot scaffold & core architecture |
| `ISSUE-2xx` | Reusable components & systems |
| `ISSUE-3xx` | Shaders & visual effects |
| `ISSUE-4xx` | UI layer |
| `ISSUE-5xx` | Audio |
| `ISSUE-6xx` | Art & animation assets |
| `ISSUE-7xx` | Narrative & dialogue (Dialogic) |
| `ISSUE-8xx` | Cycle 0 content & scenes |
| `ISSUE-9xx` | Cycle 1 content & Café scene |
| `ISSUE-10x` | Integration, QA & Vertical Slice ship |

### Assignee guidance

| Tag | Who |
|---|---|
| `human-required` | Creative decisions, naming protagonist, composing music, final art approval |
| `ai-suitable` | Boilerplate code, scaffolding, shader stubs, dialogue file structure |
| `collaborative` | Scene assembly, dialogue writing (AI drafts → human edits tone) |

---

## GitHub Milestones

| Order | Milestone ID | Name | Exit criteria |
|---|---|---|---|
| 1 | `M0` | Repository & Godot Init | Empty Godot 4 project runs; folder tree matches RULES.md §13 |
| 2 | `M1` | Core Systems | All autoloads exist; EventBus wired; verb + saturation systems functional in isolation |
| 3 | `M2` | Components & Shaders | Interactable pipeline works; saturation visible via shaders (no UI bar) |
| 4 | `M3` | UI & Localization | Full HUD; FR/EN toggle; save screen shows "Demain." / "Tomorrow." |
| 5 | `M4` | Audio Foundation | Buses configured; spatial rules documented in code; piano motif placeholder |
| 6 | `M5` | Art Pipeline | Style guide locked; marionette rig template; one test scene animated |
| 7 | `M6` | Dialogic & Narrative Pipeline | Dialogic integrated; inner monologue track separated; bilingual file tree |
| 8 | `M7` | Cycle 0 Playable | Full Cycle 0 from apartment → districts → Elena gaze → save |
| 9 | `M8` | Cycle 1 Playable | Full Cycle 1 district traversal → Café scene → home return |
| 10 | `M9` | Vertical Slice Ship | 45–60 min playthrough; no blockers; bilingual; builds export |

---

## GitHub Labels

```
area:core          area:components    area:shaders       area:ui
area:audio         area:art           area:narrative     area:scenes
area:infra         area:qa
cycle:0            cycle:1            cycle:future
lang:gdscript      lang:dialogic      lang:shader
priority:critical  priority:high      priority:medium    priority:low
type:feature       type:bug           type:docs          type:asset
human-required     ai-suitable        collaborative
blocked:design     vertical-slice
```

---

## Dependency Graph (summary)

```
M0 (001–004)
  └─► M1 (101–108)
        └─► M2 (201–206, 301–306)
              └─► M3 (401–408) + M4 (501–507) + M5 (601–608)  [parallel]
                    └─► M6 (701–709)
                          └─► M7 (801–812)
                                └─► M8 (901–911)
                                      └─► M9 (1001–1005)
```

---

## Roadmap schedule (GitHub Project)

**Anchor:** `2026-07-01` — ISSUE-001 / [#1](https://github.com/LionGon/JustCoffee/issues/1)  
**Vertical Slice target:** `2026-09-29` — ISSUE-1005 / [#73](https://github.com/LionGon/JustCoffee/issues/73)

Dates are applied on the [GitHub Project board](https://github.com/users/LionGon/projects/8) as **Start date** and **Target date**. Open the project → **+ New view** → **Roadmap** to see the timeline.

| Phase | Dates | Parallel tracks |
|---|---|---|
| M0 Init | Jul 1–6 | #1–#4 sequential |
| M1 Core | Jul 7–14 | #106 Localization ∥ #101–103; #105 ∥ #104 |
| M2 Components + Shaders | Jul 10–24 | #301–305, #501, #505 ∥ components; #205 ∥ #201 |
| M3 UI + M4 Audio + M5 Art | Jul 7–Aug 2 | Three parallel tracks; #503 piano Jul 14–20 |
| M6 Narrative | Jul 8–Aug 10 | #701–702 early; #705–706 Aug |
| M7–M8 Cycles | Aug 11–Sep 17 | #901–902 parallel; #908 ∥ café beats |
| M9 Ship | Sep 18–29 | #1003 perf ∥ QA |

Source of truth for dates: [`scripts/roadmap_schedule.py`](../scripts/roadmap_schedule.py)  
Re-apply after edits: `python3 scripts/apply_roadmap_dates.py`

---

# TASK LIST (ordered)

---

## M0 — Repository & Godot Init

---

### ISSUE-001 — Initialize GitHub repository and project board

**Labels:** `area:infra`, `priority:critical`, `ai-suitable`  
**Milestone:** M0  
**Depends on:** —  
**Assignee:** AI or human

#### Objective
Create the canonical GitHub home for Just Coffee with enough structure that any agent can pick up work immediately.

#### Detailed requirements
1. Create repository `just-coffee` (or match existing local folder name).
2. Add `README.md` with:
   - One-paragraph pitch (psychological P&C adventure, Godot 4, bilingual)
   - Link to `RULES.md` as single source of truth
   - Engine version pin (Godot 4.3+ recommended; document exact version in README)
   - How to open project (`project.godot`)
   - Headphone recommendation note (RULES.md §10)
3. Copy `RULES.md` to repo root (already exists locally).
4. Add `tasks/PRODUCTION_PLAN.md` (this file).
5. Create GitHub Project board with columns: Backlog, Ready, In Progress, Review, Done.
6. Create all milestones M0–M9 and labels listed above.
7. Enable Issues and (optional) Discussions for design gaps flagged per RULES.md §16 rule 9.

#### Acceptance criteria
- [ ] Repo exists with README, RULES.md, tasks/PRODUCTION_PLAN.md
- [ ] All milestones and labels created
- [ ] Project board exists and is linked from README
- [ ] `assets/cafe-scene.png` committed as visual reference (not necessarily in-game asset yet)

#### Files
- `README.md`
- `.github/` (optional: issue templates — see ISSUE-002)

---

### ISSUE-002 — GitHub issue templates and CONTRIBUTING guide

**Labels:** `area:infra`, `type:docs`, `ai-suitable`  
**Milestone:** M0  
**Depends on:** ISSUE-001

#### Objective
Standardize how humans and agents file work so nothing contradicts RULES.md.

#### Detailed requirements
1. Create `.github/ISSUE_TEMPLATE/bug_report.md` — must ask: cycle, district, language, steps.
2. Create `.github/ISSUE_TEMPLATE/feature_request.md` — must include: "Does this contradict RULES.md? If yes, stop."
3. Create `.github/ISSUE_TEMPLATE/design_gap.md` — for unspecified decisions (RULES.md §16.9): describe gap, proposed options, **no implementation until confirmed**.
4. Create `CONTRIBUTING.md`:
   - Read RULES.md first, always
   - GDScript only, static typing always (§13)
   - Never use standard P&C verbs (Look At, Use, Talk To, Pick Up)
   - Never expose Saturation as UI
   - Never add mechanical protection from outfit choice (§6.3)
   - EventBus for cross-system signals — no direct node coupling (§13)
   - Comments in English; dialogue in FR primary, EN adapted (§12)
5. Create `.github/pull_request_template.md` checklist mirroring CONTRIBUTING rules.

#### Acceptance criteria
- [ ] Three issue templates usable from GitHub UI
- [ ] CONTRIBUTING.md and PR template committed
- [ ] PR template includes "Read RULES.md" checkbox

---

### ISSUE-003 — Godot 4 project scaffold and folder structure

**Labels:** `area:infra`, `area:core`, `priority:critical`, `ai-suitable`  
**Milestone:** M0  
**Depends on:** ISSUE-001

#### Objective
Create `project.godot` and the exact directory tree from RULES.md §13.

#### Detailed requirements
Create empty folder structure (with `.gitkeep` where needed):

```
res://
├── core/
├── components/
├── scenes/cycles/cycle_0/
├── scenes/cycles/cycle_1/
├── scenes/districts/threshold/
├── scenes/districts/artery/
├── scenes/districts/corridor/
├── scenes/districts/square/
├── scenes/districts/cafe/
├── scenes/ui/
├── scripts/systems/
├── assets/backgrounds/
├── assets/shaders/
├── assets/characters/
├── assets/audio/ambience/
├── assets/audio/music/
├── assets/audio/voice/
├── assets/ui/
├── data/dialogues/fr/
├── data/dialogues/en/
├── data/game_state/
```

Project settings:
- Display: 1920×1080 base, stretch mode suitable for 2D adventure
- Rendering: Forward+ or Compatibility — document choice in README (2D-heavy; Compatibility acceptable for broader hardware)
- Input map: placeholder actions for verb selection and click
- Autoload slots reserved (empty scripts OK for now): `EventBus`, `SaturationManager`, `CycleStateManager`, `InventoryManager`, `LocalizationManager`, `GameFlags`
- Main scene: temporary boot scene (`scenes/ui/boot.tscn`) that quits or shows "Just Coffee — WIP"

Add `.gitignore` for Godot (`.godot/`, `*.import`, export presets local overrides, `.DS_Store`).

#### Acceptance criteria
- [ ] Project opens in Godot 4 without errors
- [ ] Folder tree matches RULES.md §13 exactly
- [ ] Six autoload names registered (scripts can be stubs)
- [ ] Main scene runs (blank or boot message)

#### Files
- `project.godot`
- `.gitignore`
- `scenes/ui/boot.tscn` + minimal script

---

### ISSUE-004 — Export presets and version pinning

**Labels:** `area:infra`, `priority:medium`, `ai-suitable`  
**Milestone:** M0  
**Depends on:** ISSUE-003

#### Objective
Enable repeatable builds for playtesting the Vertical Slice.

#### Detailed requirements
1. Document Godot version in `README.md` and optionally `/.godot-version` or `docs/ENGINE.md`.
2. Add export presets for:
   - **Windows Desktop** (primary playtest)
   - **macOS** (developer machine)
   - **Linux/X11** (optional)
3. Export icon: placeholder OK.
4. Document export steps in README (no secrets in repo).

#### Acceptance criteria
- [ ] Export preset files committed (no credentials)
- [ ] README documents engine version and export command
- [ ] One successful debug export documented in issue comment or QA log

---

## M1 — Core Systems (Autoloads)

---

### ISSUE-101 — EventBus autoload (global signals)

**Labels:** `area:core`, `priority:critical`, `ai-suitable`  
**Milestone:** M1  
**Depends on:** ISSUE-003

#### Objective
Single signal hub for all cross-system communication (RULES.md §13).

#### Detailed requirements
Implement `core/event_bus.gd` as autoload with at minimum:

```gdscript
signal saturation_changed(new_level: float)
signal verb_selected(verb: int)
signal cycle_advanced(new_cycle: int)
signal district_changed(district_id: String)
signal sanctuary_entered(sanctuary_id: String)
signal reflection_mode_toggled(active: bool)
signal inner_monologue_triggered(text_key: String)
signal interactable_clicked(interactable_id: String)
signal dialogue_started(dialogue_id: String)
signal dialogue_finished(dialogue_id: String)
signal game_saved(slot_id: int)
signal dissociation_state_changed(active: bool)
```

- All signals documented with brief English comments
- Static typing on any helper methods
- No game logic in EventBus — signals only

#### Acceptance criteria
- [ ] Autoload registered as `EventBus`
- [ ] Test scene can emit and receive each signal
- [ ] No `get_node()` coupling between systems in this file

#### Files
- `core/event_bus.gd`

---

### ISSUE-102 — GameFlags autoload (narrative persistence)

**Labels:** `area:core`, `priority:high`, `ai-suitable`  
**Milestone:** M1  
**Depends on:** ISSUE-101

#### Objective
Central store for boolean/string narrative flags used by Dialogic and scene logic.

#### Detailed requirements
1. `core/game_flags.gd` — typed dictionary or Resource-backed flag set.
2. Methods: `set_flag(key: String, value: Variant) -> void`, `get_flag(key: String, default: Variant = null) -> Variant`, `has_flag(key: String) -> bool`, `reset_cycle_flags(cycle: int) -> void`.
3. Seed flags needed for Vertical Slice:
   - `elena_gaze_complete` (Cycle 0 end)
   - `cafe_spill_occurred`
   - `marc_apologized` (always true after café beat 8 — displacement of apology)
   - `inner_monologue_silent` (post-Elena)
   - `selected_outfit_id`
4. Save/load hooks stubbed for ISSUE-407.

#### Acceptance criteria
- [ ] Flags persist during session
- [ ] Cycle reset partial logic documented in comments (full behavior in ISSUE-104)
- [ ] Static typing throughout

---

### ISSUE-103 — CycleStateManager autoload

**Labels:** `area:core`, `priority:critical`, `ai-suitable`  
**Milestone:** M1  
**Depends on:** ISSUE-101, ISSUE-102

#### Objective
Track current cycle (0–4), district, scene, and drive autosave triggers.

#### Detailed requirements
1. `core/cycle_state_manager.gd`
2. Enums or constants:
   - Cycles: `0` through `4`, plus `EPILOGUE` reserved
   - Districts: `threshold`, `artery`, `corridor`, `square`, `cafe` (fixed order §2)
3. Properties: `current_cycle: int`, `current_district: String`, `district_index: int`
4. Methods:
   - `advance_district() -> void` — emits `district_changed`, triggers autosave (stub)
   - `set_cycle(cycle: int) -> void` — emits `cycle_advanced`
   - `get_verb_availability() -> Dictionary` — delegates to verb rules §6.4 (FORCER greyed cycle 3+)
5. Sawtooth saturation reset: `get_cycle_opening_saturation_base() -> float` — partial reset, not zero after Cycle 1 (§6.1)
6. **No manual save during Café scenes** — flag `is_cafe_scene: bool` blocks save UI

#### Acceptance criteria
- [ ] District order enforced
- [ ] Cycle 0 and Cycle 1 selectable for dev boot
- [ ] Autosave signal emitted on district transition
- [ ] Café scene save block documented and testable

---

### ISSUE-104 — SaturationManager autoload

**Labels:** `area:core`, `priority:critical`, `ai-suitable`  
**Milestone:** M1  
**Depends on:** ISSUE-101, ISSUE-103

#### Objective
Track saturation 0.0–1.0; drive shaders and audio; trigger dissociation at 0.85 — **never expose value to UI** (§6.1).

#### Detailed requirements
1. `core/saturation_manager.gd`
2. Constants: `DISSOCIATION_THRESHOLD: float = 0.85`
3. Methods:
   - `add_saturation(delta: float, source: String) -> void`
   - `reduce_saturation(delta: float, source: String) -> void` — micro-sanctuary hooks
   - `apply_cycle_opening_reset(cycle: int) -> void` — partial reset per sawtooth
   - `apply_saturation() -> void` — updates shader params via EventBus or direct ref to overlay node group
   - `dissociation_state() -> void` — triggers silhouette NPC rendering, camera drift (implemented in ISSUE-305, ISSUE-306)
4. Third unnamed saturation state after Elena gaze (§5) — enum or flag `post_elena_state: bool` altering visual/audio curve
5. Emit `saturation_changed` — listeners must NOT be UI label; shaders/audio only

#### Acceptance criteria
- [ ] No UI node reads `saturation_level`
- [ ] Dissociation triggers at ≥ 0.85 without game over
- [ ] Post-Elena state changes behavior once flag set
- [ ] Unit test or debug scene adjusts saturation with keyboard

---

### ISSUE-105 — InventoryManager (Strategy inventory)

**Labels:** `area:core`, `priority:high`, `ai-suitable`  
**Milestone:** M1  
**Depends on:** ISSUE-101

#### Objective
Manage strategy items — **not** protective stats (§6.3).

#### Detailed requirements
1. `core/inventory_manager.gd`
2. Resource type `data/game_state/strategy_item.gd`:
   - `id: String`, `name_key: String`, `description_key: String`, `mechanic_type: String`, `cost_description_key: String`, `single_use: bool`
3. Vertical Slice items (minimum):
   - Phone screen on — blocks gaze analysis, lose environmental data
   - Headphones — muffles hostile audio, unpredictable gaze vectors
   - Alternative route — +8 min narrative cost (flag only in VS)
   - Fake phone call — one-shot defuse
   - Eyes down — sustained saturation drain
   - Keys between fingers — narrative only, always in inventory
4. Methods: `add_item`, `remove_item`, `has_item`, `use_item(id) -> bool`, `get_all_items() -> Array`
5. **Outfit selection stores cosmetic id only — zero effect on harassment probability**

#### Acceptance criteria
- [ ] Items display in UI bar (ISSUE-405) by name key
- [ ] Using phone blocks OBSERVER gaze text for a scene (hook for ISSUE-203)
- [ ] No stat named "Discretion" affects gameplay logic

---

### ISSUE-106 — LocalizationManager autoload

**Labels:** `area:core`, `lang:gdscript`, `priority:high`, `ai-suitable`  
**Milestone:** M1  
**Depends on:** ISSUE-003

#### Objective
FR/EN toggle and string retrieval (§12).

#### Detailed requirements
1. `core/localization_manager.gd`
2. Locale: `"fr"` default, `"en"` secondary
3. Methods: `set_locale(locale: String) -> void`, `get_locale() -> String`, `tr(key: String) -> String`
4. CSV or JSON string tables in `data/localization/ui_fr.csv`, `ui_en.csv` for non-Dialogic UI
5. Emit signal on locale change for UI refresh
6. Pause menu language toggle (wired in ISSUE-408)

#### Acceptance criteria
- [ ] Default FR on first launch
- [ ] Toggle switches all UI chrome strings instantly
- [ ] Dialogic locale sync method documented

---

### ISSUE-107 — Verb system (`scripts/systems/verb_system.gd`)

**Labels:** `area:core`, `priority:critical`, `ai-suitable`  
**Milestone:** M1  
**Depends on:** ISSUE-101, ISSUE-103

#### Objective
Ten custom verbs with cycle-gated availability (§6.4).

#### Detailed requirements
1. Enum `Verb` exactly:
   ```
   OBSERVER, ABORDER, ECOUTER, RETENIR, UTILISER,
   ALLER, EVITER, CEDER, FORCER, RECULER
   ```
2. English display names separate from enum (OBSERVE, APPROACH, etc.)
3. `get_available_verbs(cycle: int) -> Array[Verb]`
4. `is_verb_greyed(verb: Verb, cycle: int, context: Dictionary) -> bool`:
   - FORCER greyed Cycle 3+ (VS only needs Cycle 0–1 logic but implement full rule)
   - ABORDER greyed on some NPCs Cycle 3+ (stub context keys)
   - RECULER can be force-selected by scene (player agency removed)
5. `select_verb(verb: Verb) -> void` — emits `verb_selected`
6. **Never** label verbs Look At / Use / Talk To / Pick Up in code or UI

#### Acceptance criteria
- [ ] All 10 verbs in enum with FR/EN labels
- [ ] Cycle 0: CÉDER not needed; FORCER available
- [ ] Cycle 1: full set except future grey rules tested via debug cycle switch
- [ ] Greyed verbs visible but not clickable (UI in ISSUE-401)

---

### ISSUE-108 — Core integration test scene

**Labels:** `area:core`, `area:qa`, `priority:high`, `ai-suitable`  
**Milestone:** M1  
**Depends on:** ISSUE-101 through ISSUE-107

#### Objective
One debug scene proving all autoloads communicate via EventBus.

#### Detailed requirements
Scene `scenes/ui/core_test.tscn`:
- Buttons: +saturation, -saturation, next district, cycle 0/1 toggle, select each verb
- Label shows cycle/district (OK for debug — not player HUD)
- Print/log EventBus emissions
- Verify dissociation at 0.85

#### Acceptance criteria
- [ ] Scene runs without errors
- [ ] Documented in README as dev tool
- [ ] No production UI leaks saturation numbers

---

## M2 — Components & Interaction Pipeline

---

### ISSUE-201 — InteractableArea base component

**Labels:** `area:components`, `priority:high`, `ai-suitable`  
**Milestone:** M2  
**Depends on:** ISSUE-107

#### Objective
Clickable hotspot base for point-and-click (§13 components).

#### Detailed requirements
1. `components/interactable_area.gd` extends `Area2D`
2. Exports: `interactable_id: String`, `cursor_hint: String`, `enabled_verbs: Array[int]`
3. On click: emit `EventBus.interactable_clicked`
4. Works with verb system: only responds when selected verb is allowed
5. Static typing; no scene-specific logic — delegate to `verb_receiver` or scene Resource

#### Acceptance criteria
- [ ] Click with GO vs OBSERVER produces different EventBus payloads
- [ ] Disabled when verb greyed
- [ ] Used in at least one test hotspot

---

### ISSUE-202 — VerbReceiver component

**Labels:** `area:components`, `priority:high`, `ai-suitable`  
**Milestone:** M2  
**Depends on:** ISSUE-201, ISSUE-107

#### Objective
Maps verb + hotspot combinations to actions without logic in scene nodes (§13 data/presentation separation).

#### Detailed requirements
1. `components/verb_receiver.gd`
2. Accepts `Resource` `data/game_state/interaction_definition.gd`:
   - `interactable_id`, `verb`, `result_type` (dialogue, monologue, scene_change, flag), `payload: String`
3. Dispatches via EventBus — never calls Dialogic directly from interactable

#### Acceptance criteria
- [ ] Interactions defined as Resources, not hardcoded in `.tscn`
- [ ] At least 3 interaction types working in test scene

---

### ISSUE-203 — GazeVector component (NPC gaze cone)

**Labels:** `area:components`, `priority:critical`, `ai-suitable`  
**Milestone:** M2  
**Depends on:** ISSUE-201, ISSUE-104

#### Objective
Dynamic gaze zones for OBSERVER verb and ÉVITER routing (§6.2).

#### Detailed requirements
1. `components/gaze_vector.gd` — Area2D or Polygon2D cone
2. States tie to NPC FSM (ISSUE-204): SCANNING, LOCKED_ON, etc.
3. OBSERVER verb returns **hedged** description text key — never "He is hostile"
4. Descriptions vary by cycle for same NPC **type** (data-driven keys: `gaze_thomas_cycle_1`)
5. Saturation costs: ABORDER medium, ÉCOUTER low, OBSERVER none, ÉVITER none
6. Phone item blocks gaze analysis when active (§6.3)

#### Acceptance criteria
- [ ] OBSERVER prints localized hedged string
- [ ] Gaze description keys exist for Cycle 1 Thomas/Kevin (content in ISSUE-709)
- [ ] ÉVITER pathfinding hook documented (full nav optional in VS)

---

### ISSUE-204 — NPC state machine component

**Labels:** `area:components`, `priority:critical`, `ai-suitable`  
**Milestone:** M2  
**Depends on:** ISSUE-203

#### Objective
FSM for all NPC behavior — no if/else chains (§13).

#### Detailed requirements
1. `components/npc_state_machine.gd`
2. Enum `NPCState`: IDLE, SCANNING, LOCKED_ON, HOSTILE_LATENT, BENEVOLENT, COMPLICIT
3. Transitions driven by signals/data, not embedded dialogue
4. Marc uses COMPLICIT; grocery shopkeeper BENEVOLENT (Cycle 1+)
5. Hostile NPCs **never visually obvious** — animation stays mechanical (§9)

#### Acceptance criteria
- [ ] FSM diagram in comment header
- [ ] Invalid transitions rejected
- [ ] Marc defaults to COMPLICIT in café scene setup

---

### ISSUE-205 — Player movement and GO verb

**Labels:** `area:components`, `priority:high`, `collaborative`  
**Milestone:** M2  
**Depends on:** ISSUE-201, ISSUE-107

#### Objective
Point-and-click navigation for district scenes.

#### Detailed requirements
1. Click ground with ALLER/GO verb moves protagonist to marker
2. NavigationRegion2D or simple walk-to-point for VS scope
3. Walk animation: deliberate, slightly stiff (marionette — ISSUE-607)
4. Freeze state when dissociation active (§6.1)

#### Acceptance criteria
- [ ] Player reaches hotspots in test district
- [ ] Movement disabled appropriately during locked beats (Elena gaze)

---

### ISSUE-206 — District scene template

**Labels:** `area:scenes`, `priority:high`, `ai-suitable`  
**Milestone:** M2  
**Depends on:** ISSUE-103, ISSUE-201, ISSUE-205

#### Objective
Reusable district scene structure for all five districts.

#### Detailed requirements
Template `scenes/districts/district_template.tscn`:
- Parallax or layered background root
- Navigation layer
- Hotspot layer
- NPC layer
- Spawn point per connected district
- Location name hook for UI
- Autosave on enter via CycleStateManager
- Audio bus for district ambience

#### Acceptance criteria
- [ ] Five empty district scenes inherit or duplicate template
- [ ] Transition threshold → artery → corridor → square → cafe works in debug

---

## M3 — Shaders & Visual Effects

---

### ISSUE-301 — Saturation vignette shader (CanvasItemShader)

**Labels:** `area:shaders`, `priority:critical`, `ai-suitable`  
**Milestone:** M2  
**Depends on:** ISSUE-104

#### Objective
Hidden saturation communicated via vignette narrowing (§6.1, §13).

#### Detailed requirements
1. `assets/shaders/saturation_vignette.gdshader`
2. Applied on `ColorRect` + `BackBufferCopy` — NOT SubViewport post-process
3. Uniform `saturation_level: float` — driven only by SaturationManager
4. High saturation: vignette closes to ~60% FOV (§9)
5. Mid/high: warm tones cool 15–20% (can be second shader or combined)

#### Acceptance criteria
- [ ] Visible vignette change 0.0 → 1.0 in core_test
- [ ] No numeric display
- [ ] Performance stable on 1080p

---

### ISSUE-302 — Color desaturation shader

**Labels:** `area:shaders`, `priority:high`, `ai-suitable`  
**Milestone:** M2  
**Depends on:** ISSUE-301

#### Objective
World loses warmth as saturation rises (§6.1, §9).

#### Detailed requirements
- Near-monochrome at high saturation
- Works with perceived world palette: ochres, greys, muted blues (§9)
- Chain with vignette per performance spec

#### Acceptance criteria
- [ ] Combined effect readable in screenshot comparison
- [ ] dissociation at 0.85 visually distinct from 0.5

---

### ISSUE-303 — Dissociation camera drift shader

**Labels:** `area:shaders`, `priority:high`, `ai-suitable`  
**Milestone:** M2  
**Depends on:** ISSUE-104, ISSUE-301

#### Objective
Camera drifts ±3px when dissociation active (§9).

#### Detailed requirements
- Subtle sine drift on camera or full-screen offset
- Activates via SaturationManager.dissociation_state()
- No message to player — not game over

#### Acceptance criteria
- [ ] Drift on at ≥0.85, off below threshold
- [ ] Playable during drift

---

### ISSUE-304 — NPC silhouette layer (dissociation)

**Labels:** `area:shaders`, `area:art`, `priority:high`, `collaborative`  
**Milestone:** M2  
**Depends on:** ISSUE-303, ISSUE-606

#### Objective
NPCs render as flat silhouettes during dissociation (§6.1).

#### Detailed requirements
- Skeleton2D: hide detail layers, show silhouette layer
- Toggle via EventBus `dissociation_state_changed`
- Protagonist NOT silhouetted

#### Acceptance criteria
- [ ] Toggle tested with 2+ NPC rigs
- [ ] Still interactable (costs more saturation — optional VS scope)

---

### ISSUE-305 — Background ambient shaders (rain, steam, lamp flicker)

**Labels:** `area:shaders`, `priority:medium`, `ai-suitable`  
**Milestone:** M2  
**Depends on:** ISSUE-003

#### Objective
All background motion via shaders — no video (§9).

#### Detailed requirements
1. `rain_particle.gdshader` or GPUParticles2D + shader
2. `steam_displacement.gdshader` — noise UV
3. `lamp_flicker.gdshader` — sine-driven intensity
4. `ambient_breathe.gdshader` — subtle UV displacement
5. Apply to café window rain (reference: `assets/cafe-scene.png`)

#### Acceptance criteria
- [ ] No video files in repo
- [ ] Café exterior window shows rain in scene ISSUE-905

---

### ISSUE-306 — Reflection Mode shader (stub for Vertical Slice)

**Labels:** `area:shaders`, `priority:low`, `cycle:future`, `ai-suitable`  
**Milestone:** M2  
**Depends on:** ISSUE-301

#### Objective
Thermal negative inversion for Reflection Mode (§9) — stub for Cycle 3; brass mirror in Cycle 1 uses description only.

#### Detailed requirements
- `assets/shaders/reflection_mode_invert.gdshader`
- `scripts/systems/reflection_mode.gd` — toggles shader, disabled in Cycle 1 gameplay
- Cycle 1 mirror: text only when OBSERVER/click (§7)

#### Acceptance criteria
- [ ] Shader exists and demo toggle in core_test
- [ ] Cycle 1 café mirror does NOT activate inversion unless dev flag

---

## M4 — UI Layer

---

### ISSUE-401 — Verb bar UI (10 verbs)

**Labels:** `area:ui`, `priority:critical`, `collaborative`  
**Milestone:** M3  
**Depends on:** ISSUE-107, ISSUE-106

#### Objective
Bottom-left verb bar — custom verbs only (§11).

#### Detailed requirements
1. `scenes/ui/verb_bar.tscn`
2. Shows all 10 verbs FR or EN per locale
3. Greyed verbs: visible, not clickable (§6.4)
4. Selected verb highlighted
5. Emits via VerbSystem / EventBus

#### Acceptance criteria
- [ ] Matches layout spec: bottom left
- [ ] No standard P&C verb names anywhere
- [ ] Cycle 0 vs 1 availability visually correct

---

### ISSUE-402 — Inventory bar UI

**Labels:** `area:ui`, `priority:high`, `ai-suitable`  
**Milestone:** M3  
**Depends on:** ISSUE-105, ISSUE-106

#### Objective
Bottom bar strategy inventory always visible (§11).

#### Detailed requirements
- Icon or text slots for strategies
- UTILISER verb + click item to use
- Keys between fingers always present
- No stat tooltips implying protection

#### Acceptance criteria
- [ ] Items from InventoryManager render correctly
- [ ] Using item emits EventBus for systems to react

---

### ISSUE-403 — Location and cycle indicator

**Labels:** `area:ui`, `priority:medium`, `ai-suitable`  
**Milestone:** M3  
**Depends on:** ISSUE-103, ISSUE-106

#### Objective
Bottom-right district name + cycle indicator (§11).

#### Detailed requirements
- FR/EN district names from §2 table (Le Seuil / The Threshold, etc.)
- Cycle label: e.g. "Cycle 1 — L'Éveil" / "Cycle 1 — The Awakening"
- No quest markers or objectives

#### Acceptance criteria
- [ ] Updates on district_changed and cycle_advanced
- [ ] No objective text

---

### ISSUE-404 — Inner monologue dialogue box

**Labels:** `area:ui`, `priority:critical`, `collaborative`  
**Milestone:** M3  
**Depends on:** ISSUE-106, ISSUE-701

#### Objective
Center-bottom box for protagonist inner voice — separate from NPC dialogue (§11, §3).

#### Detailed requirements
- Distinct visual treatment from NPC speech
- Dead center audio pan for VO if added later (§10)
- Rules: logistics, rationalizations, calculations — never "I feel afraid"
- Goes **silent** after Elena gaze — box hidden or empty (§5)

#### Acceptance criteria
- [ ] Separate from Dialogic NPC layout
- [ ] Silence mode after `elena_gaze_complete` flag
- [ ] FR/EN support

---

### ISSUE-405 — Outfit selection screen (lying UI)

**Labels:** `area:ui`, `priority:high`, `human-required`, `collaborative`  
**Milestone:** M3  
**Depends on:** ISSUE-105, ISSUE-106

#### Objective
Cycle 0–1 outfit screen showing false "Estimated Discretion: High" (§6.3, §11).

#### Detailed requirements
1. Screen before leaving apartment (Cycle 0 and 1)
2. Display exactly:
   - FR: *"Discrétion estimée : Haute"*
   - EN: *"Estimated Discretion: High"*
3. **No variable changes harassment outcomes** — document in code comment
4. Store cosmetic `selected_outfit_id` only

#### Acceptance criteria
- [ ] Lie text present in both languages
- [ ] Playtest script confirms identical NPC behavior regardless of outfit
- [ ] Listed in CONTRIBUTING as permitted UI lie

---

### ISSUE-406 — Pause menu (suspended thoughts)

**Labels:** `area:ui`, `priority:medium`, `collaborative`  
**Milestone:** M3  
**Depends on:** ISSUE-106, ISSUE-408

#### Objective
Pause shows protagonist suspended thoughts — not standard menu (§11).

#### Detailed requirements
- Resume, language toggle, quit
- No saturation display
- Flavor text keys per cycle (writer task in ISSUE-708)
- Language toggle calls LocalizationManager

#### Acceptance criteria
- [ ] Does not look like generic game menu
- [ ] Language toggle works mid-game

---

### ISSUE-407 — Save system UI ("Demain." / "Tomorrow.")

**Labels:** `area:ui`, `priority:high`, `ai-suitable`  
**Milestone:** M3  
**Depends on:** ISSUE-103, ISSUE-102

#### Objective
Save slots labeled Demain/Tomorrow; silence on save (§10, §11).

#### Detailed requirements
1. No save jingle — absolute silence
2. Slot label never "Save 1"
3. Autosave on district transition
4. Block manual save in café scenes (`is_cafe_scene`)
5. Serialize: GameFlags, CycleStateManager, InventoryManager, SaturationManager state, player position

#### Acceptance criteria
- [ ] Autosave restores correctly
- [ ] Café scene manual save blocked
- [ ] Post-Elena save shows "Demain." / "Tomorrow." (§5)

---

### ISSUE-408 — Main HUD composition scene

**Labels:** `area:ui`, `priority:high`, `ai-suitable`  
**Milestone:** M3  
**Depends on:** ISSUE-401 through ISSUE-407

#### Objective
Single HUD instanced in all gameplay districts.

#### Detailed requirements
- `scenes/ui/hud.tscn` layers verb bar, inventory, location, monologue box
- **Never** add saturation bar
- Launch disclaimer: headphones recommended (first boot modal)

#### Acceptance criteria
- [ ] One HUD instance in district template
- [ ] Headphone notice on first run

---

## M5 — Audio Foundation

---

### ISSUE-501 — Audio bus layout and mixing

**Labels:** `area:audio`, `priority:high`, `collaborative`  
**Milestone:** M4  
**Depends on:** ISSUE-003

#### Objective
Bus structure for saturation muffling and spatial rules (§10).

#### Detailed requirements
Buses (minimum):
- Master
- Ambience (city)
- Music (piano)
- NPC_Voice
- Inner_Monologue
- UI (minimal — save silence)

SaturationManager reduces high-frequency ambience via bus EQ send at high saturation (§6.1).

#### Acceptance criteria
- [ ] Bus layout documented in `docs/AUDIO.md`
- [ ] High saturation audibly muffles city
- [ ] Inner monologue bus dry, center

---

### ISSUE-502 — Spatial audio positioning rules

**Labels:** `area:audio`, `priority:high`, `ai-suitable`  
**Milestone:** M4  
**Depends on:** ISSUE-501, ISSUE-204

#### Objective
Code-side panning rules for hostile vs benevolent NPCs (§10).

#### Detailed requirements
- Hostile voices: behind/beside — never frontal
- Benevolent: front, medium distance
- City ambience: stereo, slightly behind player
- Helper on NPC audio sources reading FSM state

#### Acceptance criteria
- [ ] Test NPCs audible in correct positions in café scene
- [ ] Documented in AUDIO.md

---

### ISSUE-503 — Piano motif — 8-bar composition (Cycle 1 complete)

**Labels:** `area:audio`, `human-required`, `priority:critical`  
**Milestone:** M4  
**Depends on:** ISSUE-501

#### Objective
Record/create full 8-bar warm piano theme — **only complete version in entire game** (§10).

#### Detailed requirements
1. Composer brief: fragmentation table §10 — VS needs Cycle 1 full only
2. File: `assets/audio/music/piano_cafe_theme_cycle1.ogg`
3. Plays on café entry Cycle 1 beat 1 (§7)
4. On spill: one dissonant note loops (§7 beat 6)

#### Acceptance criteria
- [ ] 8 bars complete, warm, unbroken on entry
- [ ] Dissonant loop triggers on spill event
- [ ] Cycle 0 café never plays theme

---

### ISSUE-504 — Piano degradation assets (Cycle 2–4 placeholders)

**Labels:** `area:audio`, `human-required`, `priority:low`, `cycle:future`  
**Milestone:** M4  
**Depends on:** ISSUE-503

#### Objective
Placeholder files or composer queue for fragmented versions (§10 table).

#### Detailed requirements
- Document fragmentation structure for composer
- Stub files OK for VS repo — not used in VS gameplay

#### Acceptance criteria
- [ ] `docs/PIANO_BRIEF.md` matches RULES.md table exactly

---

### ISSUE-505 — City breathing ambience bed

**Labels:** `area:audio`, `human-required`, `collaborative`  
**Milestone:** M4  
**Depends on:** ISSUE-501

#### Objective
Ambience with inhale/exhale tension pattern (§10).

#### Detailed requirements
- Loop designed for tension peaks on NPC approach
- Exhale on micro-sanctuary entry (hook via EventBus)
- District variants: artery loudest, threshold quietest

#### Acceptance criteria
- [ ] Plays in artery and café exterior
- [ ] Sanctuary enter triggers exhale mix (crossfade or volume dip)

---

### ISSUE-506 — Elena gaze three-note stinger

**Labels:** `area:audio`, `human-required`, `priority:high`  
**Milestone:** M4  
**Depends on:** ISSUE-503

#### Objective
Three piano notes — opening of café motif — then stop (§5).

#### Detailed requirements
- Plays at end Cycle 0 after eye contact
- Then silence into save screen

#### Acceptance criteria
- [ ] Exactly 3 notes, no full melody
- [ ] Timed with 2-second gaze beat

---

### ISSUE-507 — Café scene SFX (spill, silence gap)

**Labels:** `area:audio`, `collaborative`, `priority:high`  
**Milestone:** M4  
**Depends on:** ISSUE-502, ISSUE-503

#### Objective
Audio for locked café beats (§7, §10).

#### Detailed requirements
- Cup knock and spill
- Sound drop on beat 6
- 1.2 second gap between Kevin "Oh, pardon." and inaudible murmur (do not shorten)
- Hostile silence with light reverb tail

#### Acceptance criteria
- [ ] Timing matches beat script in ISSUE-909
- [ ] Kevin's murmur to Thomas genuinely inaudible/subtitled omit

---

## M6 — Art Pipeline

---

### ISSUE-601 — Visual style guide document

**Labels:** `area:art`, `type:docs`, `human-required`, `priority:critical`  
**Milestone:** M5  
**Depends on:** ISSUE-001

#### Objective
Lock "Urban Grunge Expressionism" for all asset contributors (§9).

#### Detailed requirements
`docs/VISUAL_STYLE.md`:
- References: Kentucky Route Zero × Disco Elysium — darker, urban
- Palette: perceived world vs reflection mode (§9)
- Hopper isolation framing notes
- Marionette rigging mandatory — no frame-by-frame walk cycles (§9)
- Use `assets/cafe-scene.png` as café mood reference

#### Acceptance criteria
- [ ] Approved by developer
- [ ] Linked from README

---

### ISSUE-602 — Apartment background (Threshold — Cycle 0 full)

**Labels:** `area:art`, `human-required`, `priority:critical`  
**Milestone:** M5  
**Depends on:** ISSUE-601

#### Objective
Warm amber domestic safe space — only genuinely warm scene (§8).

#### Detailed requirements
- Static illustrated background layers
- Hotspots: mug, plant, vinyl, phone, window
- Palette distinct from exterior
- Export layered PSD/Godot imports

#### Acceptance criteria
- [ ] Matches warm Cycle 0 spec
- [ ] Imported in `assets/backgrounds/threshold_apartment_cycle0.png` (+ layers)

---

### ISSUE-603 — Apartment Cycle 1 decay variants

**Labels:** `area:art`, `human-required`, `priority:high`  
**Milestone:** M5  
**Depends on:** ISSUE-602

#### Objective
Visual decay for Cycle 1 apartment (§8) — plant slightly drooping, etc.

#### Detailed requirements
Minimum for VS Cycle 1 return home:
- Plant slightly drooping
- Phone message unchanged but unanswered feel
- Window light same as Cycle 0

(Full cycle 2–4 decay deferred)

#### Acceptance criteria
- [ ] CycleStateManager swaps variant on cycle
- [ ] Decay feels "contaminated from outside"

---

### ISSUE-604 — District backgrounds (Artery, Corridor, Square)

**Labels:** `area:art`, `human-required`, `priority:high`  
**Milestone:** M5  
**Depends on:** ISSUE-601

#### Objective
Exterior districts for district traversal — VS needs playable path.

#### Detailed requirements
1. **Artery** — main commercial street, maximum exposure
2. **Corridor** — alley shortcut, vulnerable
3. **Square** — open false decompression
4. Ochres, concrete greys, muted blues; lamplight pools
5. Shader hooks for rain/flicker where needed

#### Acceptance criteria
- [ ] All three in `assets/backgrounds/`
- [ ] Placed in district scenes ISSUE-206

---

### ISSUE-605 — Café interior background ("Le Passage")

**Labels:** `area:art`, `human-required`, `priority:critical`  
**Milestone:** M5  
**Depends on:** ISSUE-601

#### Objective
Warm ochre café with brass-framed mirror on back wall (§7).

#### Detailed requirements
- Match reference `assets/cafe-scene.png` composition
- Mirror hotspot region defined
- Tables for protagonist, Thomas/Kevin adjacent
- Marc behind counter
- Menu board optional detail

#### Acceptance criteria
- [ ] Mirror clickable region aligned
- [ ] Warm ochre readable; contrast with street

---

### ISSUE-606 — Protagonist marionette rig (Skeleton2D)

**Labels:** `area:art`, `collaborative`, `priority:critical`  
**Milestone:** M5  
**Depends on:** ISSUE-601

#### Objective
[PROTAGONIST] cut-out rig — mechanical, not smoothed (§9).

#### Detailed requirements
Animations minimum:
- idle (weight shift, breathing)
- walk (stiff, deliberate)
- shoulders-up stress
- freeze (dissociation)
- head-turn (gaze response)

Dark coat, average build, unremarkable. Cycle 0 perceived male; reflection anomalies Phase 1 in ISSUE-610.

#### Acceptance criteria
- [ ] Skeleton2D only — no sprite-sheet walk
- [ ] All five animation states exist
- [ ] Instanced in district template

---

### ISSUE-607 — NPC marionette rigs (Marc, Thomas, Kevin, Elena)

**Labels:** `area:art`, `collaborative`, `priority:critical`  
**Milestone:** M5  
**Depends on:** ISSUE-606

#### Objective
Café NPCs + Elena + at least 2 street NPCs for Cycle 0.

#### Detailed requirements
| NPC | Notes |
|---|---|
| Marc | COMPLICIT animation — neutral, enabling |
| Thomas | mechanical, patron |
| Kevin | mechanical, spill beat actor |
| Elena | Cycle 0 only, recognition gaze — not afraid/angry |
| Street NPCs | generic rigs for Cycle 0 harasser POV |

Hostile NPCs more mechanical than protagonist (§9).

#### Acceptance criteria
- [ ] Marc, Thomas, Kevin placed in café scene
- [ ] Elena in Cycle 0 artery/street beat
- [ ] FSM components attached

---

### ISSUE-608 — Micro-sanctuary art (Bus shelter minimum)

**Labels:** `area:art`, `priority:medium`  
**Milestone:** M5  
**Depends on:** ISSUE-604

#### Objective
One micro-sanctuary for Cycle 1 — bus shelter (§6.5).

#### Detailed requirements
- Gaze blocked by distorted reflections in glass
- Muffled voices still audible
- Saturation reduction hook on enter

#### Acceptance criteria
- [ ] Sanctuary enter/exit works with SaturationManager
- [ ] Épicerie and headphones sanctuaries optional for VS — bus shelter required

---

### ISSUE-609 — Shop window reflection anomaly (Phase 1 Dorian)

**Labels:** `area:art`, `area:shaders`, `collaborative`, `priority:medium`  
**Milestone:** M5  
**Depends on:** ISSUE-306, ISSUE-604

#### Objective
Cycle 1 subtle wrong reflection — half-second delay, different silhouette (§4).

#### Detailed requirements
- Shop window in artery or square
- Click optional — description only in Cycle 1 café mirror
- Never state twist in text

#### Acceptance criteria
- [ ] Anomaly subtle — player may miss it
- [ ] No NPC mentions gender

---

## M7 — Dialogic & Narrative Pipeline

---

### ISSUE-701 — Install and configure Dialogic 2 plugin

**Labels:** `area:narrative`, `lang:dialogic`, `ai-suitable`, `priority:critical`  
**Milestone:** M6  
**Depends on:** ISSUE-003

#### Objective
Dialogue system per §13 — all dialogue in Dialogic.

#### Detailed requirements
1. Add Dialogic 2.x compatible with Godot 4.x via addon
2. Configure timelines folder: `data/dialogues/fr/`, `data/dialogues/en/`
3. Variables synced from GameFlags / CycleStateManager
4. Document setup in `docs/DIALOGIC.md`

#### Acceptance criteria
- [ ] Sample timeline runs in test scene
- [ ] FR and EN timeline pairs load by locale

---

### ISSUE-702 — Dialogue file naming and folder convention

**Labels:** `area:narrative`, `type:docs`, `ai-suitable`  
**Milestone:** M6  
**Depends on:** ISSUE-701

#### Objective
Predictable paths for all writers and agents (§13).

#### Detailed requirements
```
data/dialogues/[fr|en]/cycle_[n]/[district]_[scene].dtl
```
Examples:
- `fr/cycle_0/threshold_apartment.dtl`
- `fr/cycle_1/cafe_main.dtl`
- `en/cycle_1/cafe_main.dtl`

Inner monologue timelines suffix `_monologue`.

#### Acceptance criteria
- [ ] Convention documented
- [ ] Empty placeholder files for all VS scenes

---

### ISSUE-703 — Inner monologue vs NPC dialogue separation

**Labels:** `area:narrative`, `collaborative`, `priority:critical`  
**Milestone:** M6  
**Depends on:** ISSUE-701, ISSUE-404

#### Objective
Never mix inner voice and NPC speech in same UI box (§13, §3).

#### Detailed requirements
- Separate Dialogic layouts or custom handler
- Inner monologue uses `_monologue` timelines
- Style rules enforced in writing template (logistics only)

#### Acceptance criteria
- [ ] Café scene uses separate channels
- [ ] Writer template in `docs/WRITING_GUIDE.md`

---

### ISSUE-704 — Writing guide for inner monologue and gaze text

**Labels:** `area:narrative`, `type:docs`, `human-required`  
**Milestone:** M6  
**Depends on:** ISSUE-703

#### Objective
Enforce voice rules for all dialogue authors (§3, §6.2, §16).

#### Detailed requirements
`docs/WRITING_GUIDE.md`:
- Inner monologue: logistics, rationalizations, calculations — NEVER direct emotion
- Gaze text: hedged, never certain hostility
- Hostile NPCs: deniable, not cartoon villains
- No moral judgment lines
- Elena never named in-game; never referenced after Cycle 0
- Word "woman"/"femme" forbidden until final mirror Cycle 4 (not in VS)
- Marc apology line exact: *"Je suis désolé pour ça."* / *"I'm sorry about that."*

#### Acceptance criteria
- [ ] Guide reviewed and committed
- [ ] Checklist for PR review of narrative content

---

### ISSUE-705 — Cycle 0 narrative scripts (all districts)

**Labels:** `area:narrative`, `cycle:0`, `collaborative`, `priority:critical`  
**Milestone:** M6  
**Depends on:** ISSUE-702, ISSUE-704

#### Objective
Full Cycle 0 "L'Habitude" — player is unaware harasser (§2, §15).

#### Detailed requirements
Write FR first, adapt EN for each:
1. **Threshold** — apartment rituals (mug, plant, vinyl, phone, window)
2. **Outfit screen** — lie discretion text only
3. **Artery** — banal exposure; protagonist behavior constitutes harassment without game stating it
4. **Corridor / Square** — transit beats, ordinary tone
5. **Café** — NOT full Cycle 1 scene; Cycle 0 café if any is minimal (theme never heard §10)
6. **Elena beat** — street harassment implied; eye contact ending (§5):
   - No cursor, no dialogue, no monologue, 2 seconds
   - Elena: recognition, not fear/anger/disgust
   - She walks away, no look back
7. Post-beat: monologue silent, third saturation state, three piano notes, save "Demain."

#### Acceptance criteria
- [ ] Playable start-to-save in French
- [ ] English parity — no placeholder text
- [ ] No explicit moral lecturing

---

### ISSUE-706 — Cycle 0 scene implementation

**Labels:** `area:scenes`, `cycle:0`, `collaborative`, `priority:critical`  
**Milestone:** M7  
**Depends on:** ISSUE-705, ISSUE-602, ISSUE-604, ISSUE-607, ISSUE-206

#### Objective
Assemble Cycle 0 districts in Godot with Dialogic timelines.

#### Detailed requirements
- `scenes/cycles/cycle_0/` orchestrates district order
- Apartment interactions all functional (§8)
- Elena beat scripted as locked cutscene
- Transitions emit autosave
- Duration target ~45 min content scope (can be shorter in first pass)

#### Acceptance criteria
- [ ] Cycle 0 boot flag from main menu or dev menu
- [ ] Ends on save screen after Elena
- [ ] inner_monologue_silent flag set

---

### ISSUE-707 — Cycle 1 domestic opening (decayed apartment)

**Labels:** `area:scenes`, `cycle:1`, `priority:high`  
**Milestone:** M7  
**Depends on:** ISSUE-603, ISSUE-706

#### Objective
Cycle 1 opens with false normalcy 0–5 min sawtooth (§2) — worse than Cycle 0 opening subtly.

#### Detailed requirements
- Partial saturation reset on cycle start
- Apartment Cycle 1 variant
- Outfit screen again with same lying discretion
- Inner monologue returns but shifted tone (writer task)

#### Acceptance criteria
- [ ] Cycle 1 starts from save or new game path
- [ ] Sawtooth partial reset visible/audible

---

### ISSUE-708 — Pause menu flavor text (Cycles 0–1)

**Labels:** `area:narrative`, `priority:low`, `collaborative`  
**Milestone:** M6  
**Depends on:** ISSUE-406, ISSUE-704

#### Objective
Suspended thoughts text keys per cycle for pause menu.

#### Acceptance criteria
- [ ] FR/EN strings in localization files
- [ ] Logistics/computation voice — not direct emotion

---

### ISSUE-709 — Gaze description strings (Cycle 1 café NPCs)

**Labels:** `area:narrative`, `cycle:1`, `priority:high`, `collaborative`  
**Milestone:** M6  
**Depends on:** ISSUE-203, ISSUE-704

#### Objective
Locked gaze strings for Thomas and Kevin (§7).

#### Detailed requirements
Exact EN examples (adapt FR):
- Thomas: *"His gaze sweeps the room. You are in the inventory."*
- Kevin: *"He hasn't looked at you yet. Or he has, and you missed the moment."*

Same NPC **types** change gaze text by cycle — store per cycle keys.

#### Acceptance criteria
- [ ] OBSERVER verb returns these in Cycle 1 café
- [ ] Hedged tone verified against writing guide

---

## M8 — Cycle 1 & Café Scene

---

### ISSUE-901 — Cycle 1 district traversal implementation

**Labels:** `area:scenes`, `cycle:1`, `priority:critical`, `collaborative`  
**Milestone:** M8  
**Depends on:** ISSUE-707, ISSUE-604, ISSUE-203

#### Objective
Full district sequence Cycle 1 with gaze shifts — first awareness (§2).

#### Detailed requirements
1. Threshold → Artery → Corridor → Square → Café
2. Gaze vectors differ from Cycle 0 for same NPC types
3. Micro-sanctuary bus shelter available (§6.5)
4. ÉVITER verb active everywhere Cycle 1
5. NPC gendered behavior contradictions subtle — Phase 2 Dorian (§4)

#### Acceptance criteria
- [ ] All five districts reachable in order
- [ ] Autosave between districts
- [ ] Tension builds toward café

---

### ISSUE-902 — Cycle 1 narrative scripts (non-café districts)

**Labels:** `area:narrative`, `cycle:1`, `collaborative`, `priority:high`  
**Milestone:** M8  
**Depends on:** ISSUE-704, ISSUE-901

#### Objective
Dialogue and monologue for Cycle 1 exterior beats.

#### Detailed requirements
- Inner monologue: calculations, self-censorship seeds
- ABORDER risky but active
- No twist naming; inconsistencies rationalizable
- Bilingual FR/EN complete

#### Acceptance criteria
- [ ] No placeholder strings
- [ ] Tone shift from Cycle 0 banal harasser POV to unease

---

### ISSUE-903 — Café scene environment assembly

**Labels:** `area:scenes`, `cycle:1`, `priority:critical`, `collaborative`  
**Milestone:** M8  
**Depends on:** ISSUE-605, ISSUE-607, ISSUE-305

#### Objective
Build `scenes/districts/cafe/cafe_le_passage.tscn` — ~20 min scene (§7).

#### Detailed requirements
- Warm ochre interior
- Brass mirror back wall — Cycle 1 click = description only (§7)
- NPC placements: Marc, Thomas, Kevin
- Piano complete theme on entry (ISSUE-503)
- `is_cafe_scene = true` on enter

#### Acceptance criteria
- [ ] Scene matches beat structure staging
- [ ] Manual save blocked

---

### ISSUE-904 — Café scene beat script implementation (beats 1–5)

**Labels:** `area:scenes`, `cycle:1`, `priority:critical`, `collaborative`  
**Milestone:** M8  
**Depends on:** ISSUE-903, ISSUE-701

#### Objective
Entry through gaze vectors (§7 beats 1–5).

#### Detailed requirements
1. Enter — piano full warm
2. Order cappuccino — banal Marc interaction
3. Thomas and Kevin sit adjacent
4. Gaze vectors available (ISSUE-709)
5. Kevin stands, knocks cup — spill begins beat 6

#### Acceptance criteria
- [ ] Player can order drink
- [ ] Gaze OBSERVER works on both patrons
- [ ] Spill triggers on script timeline

---

### ISSUE-905 — Café scene beat script (beats 6–10) — LOCKED

**Labels:** `area:scenes`, `cycle:1`, `priority:critical`, `human-required`  
**Milestone:** M8  
**Depends on:** ISSUE-904, ISSUE-507

#### Objective
Implement locked café climax and exit — **do not redesign** (§7).

#### Detailed requirements
6. Sound drop; one dissonant piano note loops
7. Kevin: *"Oh, pardon."* — murmur to Thomas inaudible; Thomas almost-smiles
8. Marc cleans; **Marc says apology line exactly** — NOT Kevin
9. Dialogue trees B & C: internalization choices only — same physical outcome
10. Exit monologue: *"400 mètres jusqu'à chez moi. Il est 18h43. Il fait encore jour. C'était juste un café."* (EN equivalent adapted, not literal)

Brass mirror description if clicked Cycle 1:
- FR: *"Un vieux miroir. Le cadre est en laiton. Il a dû être beau, avant."*
- EN: *"An old mirror. The frame is brass. It must have been beautiful, once."*

#### Acceptance criteria
- [ ] Apology displacement verified — Marc only
- [ ] 1.2s silence gap preserved
- [ ] Choices don't change spill outcome
- [ ] Exit monologue triggers return home

---

### ISSUE-906 — Café dialogue trees B & C (writer + implementer)

**Labels:** `area:narrative`, `cycle:1`, `collaborative`, `priority:high`  
**Milestone:** M8  
**Depends on:** ISSUE-905, ISSUE-704

#### Objective
Branching internalization only — blame shifts inside protagonist, not world (§7 beat 9).

#### Detailed requirements
- FR and EN trees in Dialogic
- Flags for which internalization path — no karma meter
- Reference UI mockup choices in `assets/cafe-scene.png` as tone guide (silence vs barista attention) — map to CÉDER/YIELD or similar verbs, not moral labels

#### Acceptance criteria
- [ ] All branches rejoin same physical state
- [ ] Writing guide compliance review passed

---

### ISSUE-907 — Cycle 1 return home (brief release)

**Labels:** `area:scenes`, `cycle:1`, `priority:medium`  
**Milestone:** M8  
**Depends on:** ISSUE-905, ISSUE-603

#### Objective
Sawtooth brief release after café — apartment Cycle 1 decay (§2).

#### Detailed requirements
- Short playable or cutscene return
- Saturation partial drop — not full reset
- Sets up future Cycle 2 (no Cycle 2 content required in VS)

#### Acceptance criteria
- [ ] Return completes Vertical Slice arc
- [ ] End credits or demo end card optional

---

### ISSUE-908 — Dorian superposition Phase 1–2 subtle beats in Cycle 1

**Labels:** `area:narrative`, `area:art`, `cycle:1`, `collaborative`, `priority:medium`  
**Milestone:** M8  
**Depends on:** ISSUE-609, ISSUE-902

#### Objective
Plant anomaly reflections + one gendered NPC contradiction (§4).

#### Detailed requirements
- Window shop reflection optional beat
- One NPC behavior contradicting player expectation (e.g., condescending familiarity OR child pulled away — choose one for VS)
- Never explicit; protagonist monologue does not reference twist

#### Acceptance criteria
- [ ] Contradiction deniable
- [ ] Writing guide gender word rule intact

---

### ISSUE-909 — Protagonist naming decision

**Labels:** `blocked:design`, `human-required`, `priority:medium`  
**Milestone:** M8  
**Depends on:** —

#### Objective
Replace `[PROTAGONIST]` placeholder (§3, §15).

#### Detailed requirements
1. File GitHub `design_gap` issue with 3–5 name candidates if undecided
2. Once decided, global find replace in dialogue files only — not in RULES.md until human updates master doc
3. Inner monologue never uses name if awkward — document style choice

#### Acceptance criteria
- [ ] Name decided or explicitly remains placeholder for VS demo
- [ ] No contradictory names in shipped dialogue

---

### ISSUE-910 — Main menu and new game flow

**Labels:** `area:ui`, `area:scenes`, `priority:high`, `collaborative`  
**Milestone:** M8  
**Depends on:** ISSUE-706, ISSUE-901, ISSUE-407

#### Objective
Boot flow for Vertical Slice playtest.

#### Detailed requirements
- New Game → Cycle 0
- Continue → load save
- Dev: jump to Cycle 1 café (debug only flag)
- Language selection on first launch or pause only — document choice

#### Acceptance criteria
- [ ] Playtester can complete C0 → C1 without dev console
- [ ] Continue works after "Demain." save

---

### ISSUE-911 — Strategy inventory end demo screen (optional VS)

**Labels:** `area:ui`, `priority:low`, `cycle:1`  
**Milestone:** M8  
**Depends on:** ISSUE-907, ISSUE-105

#### Objective
At demo end, show complete strategy list — no commentary (§6.3).

#### Detailed requirements
- Plain list of collected strategies FR/EN
- No score, no moral text

#### Acceptance criteria
- [ ] List matches items collected in playthrough
- [ ] Optional — can ship VS without if time-constrained

---

## M9 — Integration, QA & Vertical Slice Ship

---

### ISSUE-1001 — Full playthrough QA script (Cycles 0–1)

**Labels:** `area:qa`, `vertical-slice`, `priority:critical`, `collaborative`  
**Milestone:** M9  
**Depends on:** ISSUE-910, ISSUE-905

#### Objective
Repeatable QA checklist for 45–60 min demo.

#### Detailed requirements
Create `docs/QA_VERTICAL_SLICE.md`:
- Step-by-step path both languages
- Verify: no saturation UI, no discretion stat effect, Marc apology, Elena rules, save silence, headphone notice
- Timing: Elena 2s, café gap 1.2s
- FORCER available Cycle 1, document Cycle 3 greyed for future
- Known gaps flagged per RULES.md §16.9

#### Acceptance criteria
- [ ] Two full playthroughs (FR + EN) logged
- [ ] All critical bugs filed as GitHub issues

---

### ISSUE-1002 — Bilingual completeness audit

**Labels:** `area:qa`, `priority:critical`, `collaborative`  
**Milestone:** M9  
**Depends on:** ISSUE-1001

#### Objective
No placeholder text in either language at VS delivery (§12).

#### Detailed requirements
- Script scans dialogue files for `TODO`, `FIXME`, `[placeholder]`
- Manual read of café locked lines for exactness

#### Acceptance criteria
- [ ] Zero placeholders in shipped `.dtl` files
- [ ] Locked lines match RULES.md exactly

---

### ISSUE-1003 — Performance pass (shaders & Skeleton2D)

**Labels:** `area:qa`, `priority:medium`, `ai-suitable`  
**Milestone:** M9  
**Depends on:** ISSUE-301, ISSUE-606

#### Objective
Stable 60fps (or documented target) at 1080p on developer machine.

#### Detailed requirements
- Profile café scene with all shaders
- BackBufferCopy saturation overlay cost measured
- No SubViewport post-process added without approval

#### Acceptance criteria
- [ ] Performance notes in QA doc
- [ ] No stutter on spill beat audio+visual transition

---

### ISSUE-1004 — Export Vertical Slice build

**Labels:** `area:infra`, `vertical-slice`, `priority:critical`, `collaborative`  
**Milestone:** M9  
**Depends on:** ISSUE-004, ISSUE-1001

#### Objective
Shippable demo binary for playtesters.

#### Detailed requirements
- Version tag `v0.1.0-vertical-slice`
- GitHub Release with build artifacts (platform TBD)
- Release notes: content scope Cycle 0 + Cycle 1, headphones recommended, content warnings (street harassment themes — factual, not moralizing)

#### Acceptance criteria
- [ ] Release published
- [ ] Fresh machine playtest successful

---

### ISSUE-1005 — Post-VS backlog epics (GitHub meta-issue)

**Labels:** `area:infra`, `cycle:future`, `type:docs`, `ai-suitable`  
**Milestone:** M9  
**Depends on:** ISSUE-1004

#### Objective
Create epic issues for post-demo work without starting them.

#### Epics to create
1. **Cycle 2 — La Mémoire** — voice-over echoes, domestic decay full table
2. **Cycle 3 — Le Filtre** — Reflection Mode voluntary, grocery self-censorship door
3. **Cycle 4 — Le Miroir** — involuntary reflection, final mirror branching endings
4. **Épilogue — Juste un café**
5. **Piano fragmentation** full composer delivery (ISSUE-504)
6. **Confrontation dialogue tree** (RULES.md §15 pending)
7. **Protagonist name** final if still placeholder

#### Acceptance criteria
- [ ] Epic issues created and milestoned beyond M9
- [ ] This PRODUCTION_PLAN.md section references them

---

# APPENDIX A — Open design gaps (do NOT implement without confirmation)

These are flagged in RULES.md §15–§16. Create `design_gap` issues before work:

| Gap | Section | Action |
|---|---|---|
| Protagonist name | §3 | ISSUE-909 |
| Cycle 2 opening domestic decay detail | §15 | Epic only |
| Confrontation dialogue tree | §15 | Epic only |
| Exact street harassment action Cycle 0 | §5 | Human writer decision — keep implicit |
| Navigation: full pathfinding vs click-to-walk | §13 | VS may use simple walk-to-point |
| Godot rendering method (Forward+ vs Compatibility) | §13 | Document in ISSUE-003 |

---

# APPENDIX B — Quick reference: Vertical Slice must include

- [ ] Cycle 0 full: apartment → districts → Elena gaze → silent monologue → "Demain." save
- [ ] Cycle 1 full: decayed opening → districts → **locked café scene** → return home
- [ ] Ten custom verbs — never standard P&C labels
- [ ] Saturation via shaders/audio only — **never UI bar**
- [ ] Outfit screen lie — no mechanical effect
- [ ] Marc apology displacement — exact line
- [ ] Piano full 8 bars Cycle 1 café entry only
- [ ] Bilingual FR/EN throughout
- [ ] Dialogic all dialogue
- [ ] Marionette Skeleton2D characters — no sprite walk cycles
- [ ] GDScript static typing only
- [ ] EventBus architecture — no cross-system direct node refs

---

# APPENDIX C — Suggested GitHub Project views

| View | Filter |
|---|---|
| Vertical Slice Critical Path | `priority:critical` + milestones M0–M9 |
| AI Pickup | `ai-suitable` + column Ready |
| Needs Human | `human-required` |
| Cycle 0 | `cycle:0` |
| Cycle 1 | `cycle:1` |
| Narrative | `area:narrative` |

---

*Generated from RULES.md v1.1 — update this plan when RULES.md changes.*
