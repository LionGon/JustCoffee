# RULES.MD — JUST COFFEE
## Master Context Document for AI-Assisted Development
### Version 1.0 — Production Reference

> **INSTRUCTION FOR ANY LLM READING THIS FILE**
> This is the single source of truth for the game "Just Coffee". Every design decision, technical choice, narrative rule, and system specification is locked here. Never contradict this document. Never propose alternatives to decisions already made. If something is not specified here, flag it explicitly before proceeding. Do not invent, assume, or extrapolate beyond what is written.

---

## 0. PROJECT IDENTITY

| Field | Value |
|---|---|
| **Title** | Just Coffee |
| **Genre** | Psychological Point-and-Click Adventure |
| **Target runtime** | 6–8 hours (full game) / 45–60 min (Vertical Slice demo) |
| **Development** | Solo developer |
| **Languages** | Bilingual — French (FR) and English (EN) simultaneously |
| **Engine** | Godot 4.x |
| **Scripting language** | GDScript exclusively — no C# |
| **Current milestone** | Vertical Slice: Cycle 0 + Cycle 1 + Café scene |

---

## 1. CORE THEMES — NEVER DILUTE THESE

The game explores the following themes. Every design decision must serve at least one of them:

- **Hyper-vigilance** — the cognitive load of constant threat assessment in public space
- **Ordinary sexism and street harassment** — presented through systemic mechanics, never through moral lecturing
- **Victim blaming** — the game never validates it; the systems actively destroy it
- **Internalized trauma** — space restriction, self-censorship, and shrinking of the possible
- **The normalization of predatory behavior** — shown through Cycle 0's unremarkable presentation of the protagonist's actions

**Core experience the player must feel:**
Constant cognitive dissonance. Self-doubt. The impossibility of finding a "correct" response. The exhaustion of existing in public space.

**What this game never does:**
- Moralizes explicitly
- Provides a "correct" solution to any harassment scenario
- Validates clothing choice as a protective factor (see Section 6.3)
- Makes hostile NPCs visually readable as threats
- Provides emotional resolution or catharsis

---

## 2. NARRATIVE STRUCTURE — THE EROSION SPIRAL

The game is structured in **5 Cycles + Epilogue**. The same day repeats, but degenerates. This is not time travel — it is the embodied repetition of trauma.

```
[Cycle 0 — "L'Habitude" / "The Habit"]         45 min   Neutral/banal. Player is the harasser.
[Cycle 1 — "L'Éveil" / "The Awakening"]         60–75 min  First awareness. Gaze vectors shift.
[Cycle 2 — "La Mémoire" / "The Memory"]         75–90 min  Previous dialogues echo as voice-over.
[Cycle 3 — "Le Filtre" / "The Filter"]          90 min   Claustrophobic. Paths disappear.
[Cycle 4 — "Le Miroir" / "The Mirror"]          60 min   Realities collapse. Involuntary switches.
[Épilogue — "Juste un café" / "Just Coffee"]    30 min   Player decides the ending. No resolution.
```

### Cycle Architecture — Sawtooth, NOT Linear Descent

Cycles do NOT continuously worsen. They follow a **sawtooth tension pattern**:
- Each cycle opens with a brief, false sense of normalcy (0–5 min)
- Tension builds through the district sequence
- Peak at the Café scene
- Brief release on return home
- The next cycle opens slightly worse than the last's opening

This prevents emotional numbness. The player must experience loss of relief, not just accumulation of dread.

### The 5 Districts (traversed in fixed order every cycle)

| District | FR Name | EN Name | Emotional State |
|---|---|---|---|
| 1 | Le Seuil | The Threshold | Apartment — preparation rituals |
| 2 | L'Artère | The Artery | Main commercial street — maximum exposure |
| 3 | Le Couloir | The Corridor | Alley shortcut — vulnerability vs. detour |
| 4 | La Place | The Square | Open space — false decompression |
| 5 | Le Café | The Café | Illusory sanctuary — cycle dénouement |

---

## 3. PROTAGONIST

| Field | Value |
|---|---|
| **Name** | [PROTAGONIST] — placeholder until named |
| **Gender presentation** | Male (Cycle 0) → perceived as female by NPCs (progressive, Cycles 1–4) |
| **Age** | Early 30s |
| **Appearance** | Dark coat, average build, deliberately unremarkable |
| **Cycle 0 identity** | Ordinary harasser — unaware his behavior constitutes harassment |
| **Arc** | Progressive guilt / ambiguous redemption — player decides whether he makes the connection |
| **Voice** | Inner monologue only — never spoken aloud, never heard by player as audio |

### Inner Monologue Rules

The protagonist's inner voice **never** expresses emotions directly. It expresses:
- Logistics: *"400 meters to home. It's 18:43."*
- Rationalizations: *"She was probably in a hurry. Or pretending."*
- Calculations: *"Three men at the corner. The left route adds 8 minutes."*
- Self-censorship: *"I shouldn't have looked."*

**The voice never says:** "I feel afraid." "I am angry." "This is unfair."
**The voice always says:** what the protagonist is computing, not what he is feeling.

---

## 4. THE CORE TWIST — DORIAN SUPERPOSITION

> **CRITICAL — READ BEFORE WRITING ANY SCENE FROM CYCLE 1 ONWARD**

### The Mechanic

NPCs progressively perceive [PROTAGONIST] as a woman. The player does not understand this immediately. It is never stated explicitly until the final mirror in Cycle 4.

### The 4-Phase Reveal

**Phase 1 — Cycle 0–1: The Anomaly**
Reflections in shop windows, puddles, and spoons are slightly wrong. The silhouette has different proportions. Half a second delayed. No dialogue references it. The player notices or doesn't.

**Phase 2 — Cycle 2–3: The Dissonance**
NPC behavior is gendered in ways that contradict what the player sees. Examples:
- A mother pulls her child away when [PROTAGONIST] passes (reacting to perceived male threat)
- Other men address [PROTAGONIST] with condescending familiarity
- The Gaze Vectors read differently than the protagonist's behavior would warrant
Two simultaneous readings of every scene now exist. The game never resolves the contradiction.

**Phase 3 — Cycle 3: Reflection Mode Unlocked**
Player can click any mirrored surface to see the scene as others perceive it.
- Dialogues change entirely in Reflection Mode
- Threat levels invert
- The barista's behavior in the café reads differently
This mode is voluntary in Cycle 3.

**Phase 4 — Cycle 4: The Merge**
Reflection Mode triggers involuntarily. The player does not control when the perspective switches. This is intentional — it is not a bug, it is the point. The loss of control over one's own perception IS the message.

**The Final Mirror — Café, Cycle 4:**
[PROTAGONIST] stands before the large brass-framed mirror. The player can:
- Click to look → full explicit revelation
- Not click → the game ends in total ambiguity
Both endings are valid. Both are sad. Neither provides resolution.

### Rules for Writing Scenes with the Dorian Superposition

- NEVER have an NPC explicitly say [PROTAGONIST] is a woman
- NEVER have [PROTAGONIST]'s inner monologue reference the twist
- NPC behavioral inconsistencies must be subtle enough to rationalize away in Cycles 1–2
- In Cycle 3+, inconsistencies become undeniable but still never named
- The word "woman" / "femme" does not appear in any dialogue until the final mirror scene (if the player chooses to look)

---

## 5. THE TRIGGERING EVENT — ELENA'S GAZE

### What Happens

At the end of Cycle 0, [PROTAGONIST] makes eye contact with **ELENA** — a woman he has just street-harassed (the nature of the harassment is left partially implicit).

**The beat:**
- No cursor
- No dialogue options
- No inner monologue
- 2 seconds of mutual eye contact
- Elena does not look afraid. Not angry. Not disgusted.
- She looks at him with **recognition**
- She continues walking. Does not look back.

**What changes after this moment:**
- The inner monologue goes silent for the first time in the game
- The Saturation shifts to an unnamed third state (neither anxiety nor safety)
- Three piano notes play — the opening of the café motif — then stop
- The save screen appears: labeled **"Demain." / "Tomorrow."**

### Rules for Elena

- Elena appears ONLY in Cycle 0, at this moment
- She is never named in-game — her name exists only in the GDD
- She never reappears in any cycle
- She is never referenced in any dialogue, inner monologue, or NPC conversation
- Her absence is her presence

---

## 6. GAMEPLAY SYSTEMS

### 6.1 The Saturation Gauge

**CRITICAL RULE: The Saturation Gauge is ALWAYS hidden. It is NEVER displayed as a UI bar, number, or icon.**

The player perceives Saturation exclusively through:
- **Visual:** Screen vignetting (Godot shader) — field of view narrows
- **Visual:** Color desaturation — world loses warmth progressively
- **Audio:** High frequency audio loss — city sounds become muffled
- **Audio:** Inner monologue becomes shorter, more clipped
- **Gameplay:** At peak Saturation → Dissociation State activates

**Dissociation State:**
- Camera drifts slightly (shader)
- NPCs render as silhouettes only
- Still playable — but every interaction costs more
- Not a game over state — a condition to play through

**Saturation follows sawtooth pattern per cycle:**
- Resets partially (NOT fully) at each cycle's opening
- Micro-Sanctuaries provide temporary reduction
- No mechanic fully resets it to zero after Cycle 1

### 6.2 The Gaze Mechanic (Vecteurs de Regard)

Each NPC has a dynamic gaze vector. The player interacts via the verb bar.

| Verb | Effect on NPC Gaze | Saturation Cost |
|---|---|---|
| OBSERVER | Reveals gaze intent (description only) | None |
| ABORDER | Initiates dialogue — NPC reacts to being approached | Medium |
| ÉCOUTER | Captures ambient dialogue without engagement | Low |
| ÉVITER | Routes around NPC gaze zone | None |

**Gaze description rules:**
- Never certain. Always hedged.
- FR: *"Son regard glisse sur la salle. Vous êtes dans l'inventaire."*
- EN: *"His gaze sweeps the room. You are in the inventory."*
- Never: *"He is hostile."* Always: *"Something in his posture suggests he has already decided something."*

**Gaze descriptions change per cycle** for the same NPC type, even if the NPC is different. The player learns to read patterns, not individuals.

### 6.3 The Strategy Inventory

**[CRITICAL — VICTIM BLAMING RULE]**
Clothing choice and any item in the inventory **NEVER** provides mechanical protection against harassment. No stat. No probability reduction. No "Discretion: High" that actually works.

The outfit selection screen in Cycle 0–1 displays:
- FR: *"Discrétion estimée : Haute"*
- EN: *"Estimated Discretion: High"*

This is a LIE. The interface lies. Harassment rates are identical regardless of outfit. This is discovered by the player through play, never stated.

**Inventory items are Strategies, not Objects:**

| Item (FR) | Item (EN) | Mechanic | Cost |
|---|---|---|---|
| Téléphone écran allumé | Phone — screen on | Blocks gaze analysis | Lose environmental data |
| Écouteurs | Headphones | Muffles hostile audio | NPC gaze vectors become unpredictable |
| Trajet alternatif | Alternative route | Avoids a hostile zone | +8 min walk, fatigue accumulation |
| Faux appel | Fake phone call | Defuses one approach | Burns the tool for the scene |
| Yeux baissés | Eyes down | Sustained posture — not a single action | Sustained Saturation drain |
| Clés entre les doigts | Keys between fingers | Passive — always in inventory | Narrative only, no mechanic |

**The inventory is the message:**
At game end, the complete list of strategies collected is displayed. No commentary. No score. Just the list. The player reads it and understands.

### 6.4 The Verb Bar — 10 Custom Verbs

**Standard point-and-click grammar is REPLACED.** Never use Look At / Use / Talk To / Pick Up in any code, UI, or design document.

```
[ OBSERVER ]  [ ABORDER ]  [ ÉCOUTER ]  [ RETENIR ]  [ UTILISER ]
[ ALLER ]     [ ÉVITER ]   [ CÉDER ]    [ FORCER ]   [ RECULER ]
```

**English equivalents (bilingual build):**
```
[ OBSERVE ]  [ APPROACH ]  [ LISTEN ]  [ HOLD BACK ]  [ USE ]
[ GO ]       [ AVOID ]     [ YIELD ]   [ FORCE ]      [ RETREAT ]
```

**Verb availability by cycle:**

| Verb / FR | Cycle 0 | Cycle 1–2 | Cycle 3–4 |
|---|---|---|---|
| ABORDER / APPROACH | Always active | Active, risky | Greyed on some NPCs |
| ÉVITER / AVOID | Rarely needed | Active everywhere | Sometimes the only option |
| FORCER / FORCE | Available, no cost | Available, costly | GREYED OUT — removed |
| CÉDER / YIELD | Never needed | Available | Always available. Always costly. |
| RECULER / RETREAT | Available, never useful | Defensive utility | Auto-triggers on some scenes — choice removed |

**The removal of FORCER in Cycles 3–4 is a narrative statement, not a balancing decision. Do not restore it.**

### 6.5 Micro-Sanctuaries

Safe zones exist in every district. They are NOT fully safe. They provide temporary Saturation reduction with a narrative cost.

| Sanctuary (FR/EN) | Relief Mechanic | The Crack |
|---|---|---|
| Abribus / Bus Shelter | Gaze vectors blocked by window reflections — but distorted, not readable | Muffled voices still audible. You must leave. |
| Épicerie / Grocery Store | Neutral/warm NPC (elderly shopkeeper). Audio changes. Saturation drops. | The shopkeeper closes. An external event ejects the player — never a timer. |
| Écouteurs activés / Headphones on | Street aggression muffled by music | NPC gaze vectors become unreadable. You don't hear them coming. |

**Micro-Sanctuary Temporal Decay across Cycles:**

| Sanctuary | Cycle 1 | Cycle 2 | Cycle 3 | Cycle 4 |
|---|---|---|---|---|
| Bus Shelter | Available | Available, shorter relief | Available, degraded | Available |
| Grocery Store | Full relief | Reduced relief | **SELF-CENSORSHIP TRIGGERS** | Does not appear on map |
| Headphones | Available | Available | Available, music skips | Available, music gone — silence only |

**SELF-CENSORSHIP RULE (Cycle 3, Grocery Store):**
The door is not locked. The store is open. Clicking the door triggers inner monologue:
- FR: *"Je ne peux pas. Pas aujourd'hui. Trop de regards à l'intérieur."*
- EN: *"I can't. Not today. Too many eyes inside."*
The player cannot enter. No explanation is given by the game. The trauma restricts the interactive space. **This is not a bug. Do not fix it.**

---

## 7. THE CAFÉ SCENE — CYCLE 1 (LOCKED)

> This scene is script-locked. Do not redesign. Only expand or write dialogue variations for other cycles.

### Setup
- Duration: ~20 minutes
- Location: "Le Passage" café — warm ochre tones, brass-framed mirror on back wall
- NPCs present: MARC (barista, neutral-complicit), THOMAS and KEVIN (patrons)

### Beat Structure
1. [PROTAGONIST] enters. Piano theme plays — complete and warm. Only time in the game.
2. Commands cappuccino. Banal interaction with Marc.
3. Thomas and Kevin enter, sit at adjacent table.
4. Gaze vectors available: Thomas ("His gaze sweeps the room. You are in the inventory."), Kevin ("He hasn't looked at you yet. Or he has, and you missed the moment.")
5. Kevin stands, passes [PROTAGONIST]'s table — knocks the cup. Cappuccino spills.
6. **Sound drops. Piano hits one dissonant note. Loops.**
7. Kevin: *"Oh, pardon."* Then says something inaudible to Thomas. Thomas almost-smiles.
8. Marc cleans up. Says: *"Je suis désolé pour ça." / "I'm sorry about that."* — **Marc apologizes instead of Kevin. This is the scene's central act.**
9. Dialogue tree B & C: choices alter only how [PROTAGONIST] internalizes blame — not the physical outcome.
10. Exit: *"400 mètres jusqu'à chez moi. Il est 18h43. Il fait encore jour. C'était juste un café."*

### Key Line — DO NOT PARAPHRASE OR ALTER
- FR: *"Je suis désolé pour ça."* (Marc, not Kevin)
- EN: *"I'm sorry about that."* (Marc, not Kevin)
The displacement of the apology is the scene's entire thesis. Preserve it exactly.

### The Brass Mirror
- Present in the scene in all cycles
- Cycle 1: Clickable, no anomaly. Description only: FR: *"Un vieux miroir. Le cadre est en laiton. Il a dû être beau, avant."* / EN: *"An old mirror. The frame is brass. It must have been beautiful, once."*
- Cycles 2–3: Reflection Mode available here
- Cycle 4: Final revelation scene

---

## 8. THE DOMESTIC SAFE SPACE — CYCLE 0 ONLY (FULL) / CYCLES 1–4 (DECAYING)

### Cycle 0 — Full State
The apartment is the only genuinely warm space in the game.
Interactive objects: coffee mug (specific one), plant (to water), vinyl record (to play), phone (friend's message), window (city below).
Palette: warm amber, soft — distinct from all exterior scenes.

### Decay Rules by Cycle

| Object | Cycle 0 | Cycle 1 | Cycle 2 | Cycle 3 | Cycle 4 |
|---|---|---|---|---|---|
| Plant | Healthy | Slightly drooping | Wilting | Dead | Gone |
| Phone — friend's message | *"T'as survécu ? 🙂" / "Did you survive? 🙂"* | Same, unanswered | *"Tout va bien ?"* / *"You ok?"* — tone shifted | *"Hey."* — nothing else | No message |
| Vinyl | Plays normally | Plays | Skips on one note | Skips constantly | [PROTAGONIST] doesn't put it on |
| Window light | Warm morning | Same | Harsher, bluer | Cold | [PROTAGONIST] doesn't open the blinds |
| Coffee mug | Chosen freely | Same | Grabbed without looking | [PROTAGONIST] forgets to drink it | Cup is found cold, untouched |

**The apartment degrades while [PROTAGONIST] is outside. He returns and finds the interior contaminated. He did not cause this directly — the outside world is causing it.**

---

## 9. VISUAL IDENTITY

### Art Style
**"Urban Grunge Expressionism"**
Reference hybrid: Kentucky Route Zero (geometric vector silhouettes, dreamlike space) × Disco Elysium (dense oil-painted textures, externalized mental states) — darker, more urban, less whimsical than either.

### Color Palette — Two States

**Perceived World (default):**
- Warm desaturated ochres, concrete greys, muted blues
- High contrast — dramatic pools of lamplight
- Edward Hopper spatial isolation — figures alone in large spaces

**Reflection Mode:**
- Thermal negative inversion
- Cold sources become warm, warm sources become cold
- Same scene, entirely different emotional reading

### Saturation Progression (Visual)
Saturation gauge affects the perceived world palette:
- Low Saturation: palette as designed
- Mid Saturation: warm tones cool by 15–20%
- High Saturation: near-monochrome, vignette closes to 60% of screen
- Dissociation: NPCs render as flat silhouettes, camera drifts ±3px on shader

### Character Animation — MARIONETTE RIGGING ONLY
**Frame-by-frame sprite animation is PROHIBITED for character movement.**

Reason: The slightly mechanical, rigid quality of marionette/cut-out rigging in Godot 4 (Skeleton2D) reinforces the theme of social scripts — behavior that is learned, performed, and not fully inhabited. This effect must not be smoothed out.

**Animation vocabulary for [PROTAGONIST]:**
- Idle: subtle weight shift, breathing
- Walk: deliberate, slightly stiff
- Shoulders-up: stress micro-animation (Saturation mid-high)
- Freeze: full stop, no animation (Dissociation State)
- Head-turn: gaze interaction response

**NPC animation rules:**
- Hostile/neutral NPCs: more mechanical than [PROTAGONIST]
- Benevolent NPCs (grocery shopkeeper): smoother, warmer animation — the only visual signal of safety

### Backgrounds — Godot Shaders ONLY
**No video files. No pre-rendered animations.**
All background motion via Godot shader animation:
- Rain: particle shader
- Steam: noise-based displacement shader
- Breathing/ambient life: subtle sine-wave UV displacement
- Lamp flicker: shader-driven, not keyframed

---

## 10. AUDIO DESIGN

### Spatial Audio Rules
- **Binaural design — headphone use strongly recommended (stated at game launch)**
- Hostile NPC voices arrive from **behind or beside** — never directly frontal
- Benevolent NPC voices arrive from **in front, at medium distance**
- [PROTAGONIST]'s inner monologue: **dead center, no reverb, intimate**
- City ambience: **stereo field, always slightly behind the player's perceived position**

### The Piano Theme — Fragmentation Rules

The café piano motif consists of **8 bars**. Its degradation across cycles is as follows:

| Cycle | Piano State |
|---|---|
| Cycle 0 | Never heard — the café has not yet been sanctuary |
| Cycle 1 | **Complete. All 8 bars. Warm, unbroken.** The only time. |
| Cycle 2 | Bars 7–8 missing. Theme ends abruptly. |
| Cycle 3 | Bars 5–8 missing. A single wrong note in bar 4. |
| Cycle 4 | Bars 1–4 only, played slowly. Bar 3 note is wrong. Bar 4 never resolves. |
| Epilogue | 3 isolated notes. Not a melody. A memory of a melody. |

**The composer receives this table as their brief. The fragmentation is not stylistic — it is structural narrative information.**

### City Breathing Ambience
The city ambient track is built as a **breathing pattern**:
- Inhale: tension peaks (NPC approach, hostile interaction)
- Exhale: micro-sanctuary entry, brief safety
- Players will unconsciously synchronize their breathing. This is intentional.

### Silence as Aggression
Silences between words in hostile dialogue are **mixed with light reverb tail** — they last slightly too long in the audio space. The gap between *"Oh, pardon."* and Kevin's inaudible comment to Thomas is 1.2 seconds. This is specified. Do not shorten it.

### Save System Audio
Saving the game plays no jingle. No sound. The word *"Demain." / "Tomorrow."* appears on screen. Silence.

---

## 11. UI & INTERFACE RULES

### What the UI Never Shows
- Saturation as a number, bar, or icon
- A "correct" path marker in Safety Mapping puzzles
- Moral judgment indicators
- Quest markers or objectives

### What the UI Shows
- Verb bar (10 verbs, bottom left)
- Inventory (bottom bar, always visible)
- Location name + Cycle indicator (bottom right)
- Inner monologue (dialogue box, center bottom)
- Nothing else

### Save System
- Save slots are labeled **"Demain." / "Tomorrow."** — never "Save 1", "Save 2"
- Autosave at each district transition
- No manual save during Café scenes
- The pause menu displays [PROTAGONIST]'s suspended thoughts — not a standard menu

### The Lying Interface
The UI is permitted to lie in specific, documented moments:
1. Outfit selection screen: *"Discrétion estimée : Haute / Estimated Discretion: High"* — false
2. Any future documented lie must be added to this list before implementation

---

## 12. BILINGUAL IMPLEMENTATION RULES

- All dialogue, inner monologue, and UI text exists in both FR and EN simultaneously
- FR is the primary language — written first, EN adapted (not literally translated)
- Tone in EN must match FR emotional register — some lines will differ significantly
- No placeholder text in either language at any milestone delivery
- Language toggle available at any time from pause menu
- [PROTAGONIST]'s inner monologue may have slight tonal differences between FR/EN — this is acceptable and may be used narratively

---

## 13. TECHNICAL ARCHITECTURE — GODOT 4

### Project Structure
```
res://
├── core/                        # Global systems (Autoloads, EventBus, Managers)
│   ├── event_bus.gd
│   ├── saturation_manager.gd
│   ├── cycle_state_manager.gd
│   ├── inventory_manager.gd
│   ├── localization_manager.gd
│   └── game_flags.gd
├── components/                  # Reusable node components
│   ├── interactable_area.gd     # Clickable hotspot base class
│   ├── gaze_vector.gd           # NPC gaze cone (Area2D)
│   ├── npc_state_machine.gd     # FSM for all NPC behavior
│   └── verb_receiver.gd        # Handles verb+hotspot combinations
├── scenes/
│   ├── cycles/
│   │   ├── cycle_0/
│   │   ├── cycle_1/
│   │   └── ...
│   ├── districts/
│   │   ├── threshold/
│   │   ├── artery/
│   │   ├── corridor/
│   │   ├── square/
│   │   └── cafe/
│   └── ui/
├── scripts/
│   └── systems/
│       ├── verb_system.gd
│       └── reflection_mode.gd
├── assets/
│   ├── backgrounds/             # Static illustrated backgrounds
│   ├── shaders/                 # All motion and effects
│   ├── characters/              # Skeleton2D rigs
│   ├── audio/
│   │   ├── ambience/
│   │   ├── music/
│   │   └── voice/
│   └── ui/
├── data/
│   ├── dialogues/               # Dialogic dialogue files
│   │   ├── fr/
│   │   └── en/
│   └── game_state/              # Cycle variables, inventory state (Resources)
└── RULES.MD                     # This file — always at project root
```

### Architecture Principles

**1. Data / Presentation Separation**
Use Godot `Resource` objects to store all state, dialogue data, and cycle variables. Scene nodes only read these resources and update display. No game logic lives inside scene nodes.

**2. Decoupled Communication — Event Bus (Signals)**
Systems (UI, Saturation, Dialogues, NPCs) communicate exclusively via global signals on a dedicated EventBus autoload. Direct node references (`get_parent().get_node()`) are prohibited between systems.

```gdscript
# core/event_bus.gd — Autoload
# All cross-system signals declared here

signal saturation_changed(new_level: float)
signal verb_selected(verb: int)
signal cycle_advanced(new_cycle: int)
signal sanctuary_entered(sanctuary_id: String)
signal reflection_mode_toggled(active: bool)
signal inner_monologue_triggered(text_key: String)
```

**3. NPC Behavior — Strict Finite State Machine (FSM)**
Every NPC's gaze and interaction behavior is driven by a State Machine. No NPC logic is written as a chain of if/else conditionals. States: `IDLE`, `SCANNING`, `LOCKED_ON`, `HOSTILE_LATENT`, `BENEVOLENT`, `COMPLICIT`.

```gdscript
# components/npc_state_machine.gd
enum NPCState {
    IDLE,
    SCANNING,       # Gaze vector sweeping
    LOCKED_ON,      # Gaze fixed on [PROTAGONIST]
    HOSTILE_LATENT, # Behaviorally hostile — never visually obvious
    BENEVOLENT,     # Smoother animation, warmer audio
    COMPLICIT       # Marc (barista) state — neutral enabling
}
```

**4. Static Typing — Always**
All GDScript variables and functions use explicit static types. No untyped declarations.
```gdscript
# CORRECT
var saturation_level: float = 0.0
func update_vignette(level: float) -> void:

# PROHIBITED
var saturation_level = 0.0
func update_vignette(level):
```

**5. Shader Performance — Saturation & Vignette Effects**
All saturation and vignette effects use `CanvasItemShader` applied on a `ColorRect` node in `BackBufferCopy` mode. This prevents performance impact on the 2D rendering pipeline. No post-process effects via SubViewport unless explicitly approved.

### Core Singletons (Autoload)
```gdscript
# Required Autoloads — never remove
EventBus             # Global signal bus — all cross-system communication
SaturationManager    # Tracks and applies saturation state
CycleStateManager    # Tracks current cycle, district, flags
InventoryManager     # Strategy inventory state
LocalizationManager  # FR/EN toggle and string retrieval
GameFlags            # All persistent narrative flags
```

### Saturation Manager — Specification
```gdscript
# saturation_manager.gd
# NEVER exposes saturation value to UI
# Controls: vignette shader param, color correction shader param, audio bus

var saturation_level: float = 0.0  # 0.0 = calm, 1.0 = dissociation
const DISSOCIATION_THRESHOLD: float = 0.85

func apply_saturation():
    # Updates shader parameters only — no UI
    # At DISSOCIATION_THRESHOLD: trigger dissociation_state()
    pass

func dissociation_state():
    # NPC Skeleton2D nodes: hide detail layers, show silhouette layer
    # Camera: enable drift shader
    # Do NOT end the scene. Do NOT display any message.
    pass
```

### Verb System — Specification
```gdscript
# verb_system.gd
# Manages 10 verbs + availability per cycle

enum Verb {
    OBSERVER, ABORDER, ECOUTER, RETENIR, UTILISER,
    ALLER, EVITER, CEDER, FORCER, RECULER
}

# FORCER is greyed (disabled) from Cycle 3 onward
# RECULER can be forced-triggered by scene logic (player loses agency)
# Greyed verbs: visible but not clickable — player sees the loss
```

### Dialogue System — Dialogic Plugin
- All dialogue managed through **Dialogic** plugin
- Dialogue files organized by: `/data/dialogues/[fr|en]/cycle_[n]/[scene_name].dtl`
- Variables passed from CycleStateManager to Dialogic for conditional branches
- Inner monologue is a separate dialogue track — never mixed with NPC dialogue in same box

---

## 14. WHAT THIS GAME IS NOT — HARD LIMITS

These are not stylistic preferences. They are structural prohibitions.

1. **Not a stealth game.** Gaze vectors are not patrol routes to memorize and exploit.
2. **Not a puzzle game with solutions.** No scenario has a "correct" choice that avoids harm.
3. **Not a trauma porn experience.** Violence is never explicit, graphic, or gratuitous.
4. **Not a morality system game.** No good/evil meter. No karma. No visible consequence tracking.
5. **Not an empathy machine that resolves.** The game does not heal, fix, or reassure the player.
6. **Not a game that validates victim-blaming.** Ever. Under any framing.

---

## 15. CURRENT PRODUCTION STATUS

| Element | Status |
|---|---|
| GDD — Core Systems | ✅ Locked |
| GDD — Narrative Structure | ✅ Locked |
| Cycle 0 — Scene design | ✅ Locked |
| Cycle 1 — Café scene script | ✅ Locked |
| Visual direction | ✅ Locked |
| Audio direction | ✅ Locked |
| Technical architecture | ✅ Locked |
| Verb bar — 10 verbs | ✅ Locked |
| Protagonist name | ⚠️ Placeholder — [PROTAGONIST] |
| Cycle 2 opening — Domestic decay | 🔲 Next milestone |
| Confrontation dialogue tree | 🔲 Pending |
| Piano fragmentation — composer brief | 🔲 Pending |
| Godot project scaffold | 🔲 Pending |
| Dialogic integration | 🔲 Pending |

---

## 16. INSTRUCTIONS FOR LLM WORKING ON THIS PROJECT

1. **Always read this entire file before producing any output**
2. **Never redesign a locked element** — if you think something should change, flag it explicitly and wait for confirmation
3. **Never use standard P&C verb names** (Look At, Use, Talk To, Pick Up) — use the 10 custom verbs
4. **Never resolve ambiguity without flagging it** — this game runs on ambiguity; do not clean it up
5. **Never add moral judgment** to any scene, dialogue, or system description
6. **When writing inner monologue:** logistics and calculations only — never direct emotional expression
7. **When writing NPC dialogue:** hostile NPCs must never be unambiguously hostile — always deniable
8. **When writing code:** GDScript only, Godot 4 syntax, comments in English
9. **When a decision is not in this document:** STOP. Flag the gap. Do not invent.
10. **The interface is permitted to lie** — only in documented instances (Section 11)

---

*RULES.MD — Just Coffee — v1.1*
*Single source of truth. All other documents defer to this one.*
*v1.1 — Added: EventBus architecture, FSM NPC system, static typing enforcement, shader performance spec, core/ and components/ folder structure.*
*Last updated: production start*