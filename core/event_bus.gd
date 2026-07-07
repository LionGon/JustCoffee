extends Node
## Global signal bus for cross-system communication.
## Signals only — no game logic (RULES.md §13).


## Saturation level changed (0.0–1.0). Listeners: shaders, audio — never UI.
signal saturation_changed(new_level: float)

## Player selected a custom verb (Verb enum as int).
signal verb_selected(verb: int)

## Narrative cycle advanced (0–4, epilogue reserved separately).
signal cycle_advanced(new_cycle: int)

## Active district changed (threshold, artery, corridor, square, cafe).
signal district_changed(district_id: String)

## Player entered a micro-sanctuary zone.
signal sanctuary_entered(sanctuary_id: String)

## Reflection mode (thermal negative palette) toggled on or off.
signal reflection_mode_toggled(active: bool)

## Inner monologue line requested by text lookup key.
signal inner_monologue_triggered(text_key: String)

## Point-and-click hotspot was clicked.
signal interactable_clicked(interactable_id: String)

## NPC or scripted dialogue sequence started.
signal dialogue_started(dialogue_id: String)

## NPC or scripted dialogue sequence finished.
signal dialogue_finished(dialogue_id: String)

## Game saved to the given slot (autosave or manual).
signal game_saved(slot_id: int)

## Dissociation state entered or exited (saturation ≥ 0.85).
signal dissociation_state_changed(active: bool)
