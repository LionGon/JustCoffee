extends Node
## Persistent narrative flags store for Dialogic branches and scene logic (RULES.md §13).
##
## Full cycle-scoped reset rules land in ISSUE-104. Until then, `reset_cycle_flags()`
## clears only district/session flags documented below — persistent arc flags survive.


## Vertical Slice seed keys — keep in sync with Dialogic variable sync (ISSUE-701).
const FLAG_ELENA_GAZE_COMPLETE: String = "elena_gaze_complete"
const FLAG_CAFE_SPILL_OCCURRED: String = "cafe_spill_occurred"
const FLAG_MARC_APOLOGIZED: String = "marc_apologized"
const FLAG_INNER_MONOLOGUE_SILENT: String = "inner_monologue_silent"
const FLAG_SELECTED_OUTFIT_ID: String = "selected_outfit_id"

## Flags cleared when entering a new cycle (ISSUE-104 will expand this list).
const _CYCLE_SCOPED_FLAGS: Array[String] = [
	FLAG_CAFE_SPILL_OCCURRED,
	FLAG_MARC_APOLOGIZED,
]

## Arc flags that survive `reset_cycle_flags()` — Elena gaze, outfit, monologue state.
const _PERSISTENT_FLAGS: Array[String] = [
	FLAG_ELENA_GAZE_COMPLETE,
	FLAG_INNER_MONOLOGUE_SILENT,
	FLAG_SELECTED_OUTFIT_ID,
]

var _flags: Dictionary = {}


func _ready() -> void:
	_seed_vertical_slice_defaults()


func set_flag(key: String, value: Variant) -> void:
	_flags[key] = value


func get_flag(key: String, default: Variant = null) -> Variant:
	if _flags.has(key):
		return _flags[key]
	return default


func has_flag(key: String) -> bool:
	return _flags.has(key)


## Partial reset when a cycle begins. Persistent arc flags are kept.
## District/session flags in `_CYCLE_SCOPED_FLAGS` revert to defaults.
## ISSUE-104: add saturation hooks, inventory wipe rules, and per-cycle seed values.
func reset_cycle_flags(cycle: int) -> void:
	for flag_key: String in _CYCLE_SCOPED_FLAGS:
		_flags.erase(flag_key)

	match cycle:
		0:
			_flags[FLAG_ELENA_GAZE_COMPLETE] = false
			_flags[FLAG_INNER_MONOLOGUE_SILENT] = false
		1:
			pass
		_:
			pass


## ISSUE-407: serialize all flags for save slots.
func serialize_state() -> Dictionary:
	return _flags.duplicate(true)


## ISSUE-407: restore flags from a save slot payload.
func deserialize_state(data: Dictionary) -> void:
	_flags = data.duplicate(true)


func _seed_vertical_slice_defaults() -> void:
	_flags[FLAG_ELENA_GAZE_COMPLETE] = false
	_flags[FLAG_CAFE_SPILL_OCCURRED] = false
	_flags[FLAG_MARC_APOLOGIZED] = false
	_flags[FLAG_INNER_MONOLOGUE_SILENT] = false
	_flags[FLAG_SELECTED_OUTFIT_ID] = ""
