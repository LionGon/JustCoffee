extends Node
## Tracks current cycle, district, and cycle-scoped navigation state (RULES.md §2, §6.4).
##
## Autosave on district transition is stubbed until ISSUE-407; emits `EventBus.game_saved`.


const CYCLE_MIN: int = 0
const CYCLE_MAX: int = 4
const EPILOGUE_CYCLE: int = 5

const DISTRICT_THRESHOLD: String = "threshold"
const DISTRICT_ARTERY: String = "artery"
const DISTRICT_CORRIDOR: String = "corridor"
const DISTRICT_SQUARE: String = "square"
const DISTRICT_CAFE: String = "cafe"

const DISTRICT_ORDER: Array[String] = [
	DISTRICT_THRESHOLD,
	DISTRICT_ARTERY,
	DISTRICT_CORRIDOR,
	DISTRICT_SQUARE,
	DISTRICT_CAFE,
]

## Matches scripts/systems/verb_system.gd order (RULES.md §6.4) — int keys for EventBus.
enum Verb {
	OBSERVER,
	ABORDER,
	ECOUTER,
	RETENIR,
	UTILISER,
	ALLER,
	EVITER,
	CEDER,
	FORCER,
	RECULER,
}

## Sawtooth opening saturation bases (§6.1). ISSUE-104 wires SaturationManager.
const _CYCLE_OPENING_SATURATION: Array[float] = [
	0.0,   # Cycle 0 — calm opening
	0.12,  # Cycle 1 — partial reset, not zero
	0.22,  # Cycle 2
	0.32,  # Cycle 3
	0.42,  # Cycle 4
	0.35,  # Epilogue — brief release before close
]

const AUTOSAVE_SLOT_ID: int = 0

var current_cycle: int = CYCLE_MIN
var current_district: String = DISTRICT_THRESHOLD
var district_index: int = 0
var is_cafe_scene: bool = false


func _ready() -> void:
	_sync_cafe_scene_flag()


func advance_district() -> void:
	if district_index >= DISTRICT_ORDER.size() - 1:
		push_warning("CycleStateManager: already at final district '%s'" % current_district)
		return

	district_index += 1
	current_district = DISTRICT_ORDER[district_index]
	_sync_cafe_scene_flag()
	EventBus.district_changed.emit(current_district)
	_trigger_autosave_stub()


func set_cycle(cycle: int) -> void:
	if not _is_valid_cycle(cycle):
		push_warning("CycleStateManager: invalid cycle %d" % cycle)
		return

	current_cycle = cycle
	district_index = 0
	current_district = DISTRICT_THRESHOLD
	_sync_cafe_scene_flag()
	GameFlags.reset_cycle_flags(current_cycle)
	EventBus.cycle_advanced.emit(current_cycle)


## Dev boot helper — jump to Cycle 0 or 1 with district at threshold.
func boot_dev_cycle(cycle: int) -> void:
	set_cycle(cycle)


func set_district(district_id: String) -> void:
	var index: int = DISTRICT_ORDER.find(district_id)
	if index < 0:
		push_warning("CycleStateManager: unknown district '%s'" % district_id)
		return

	district_index = index
	current_district = district_id
	_sync_cafe_scene_flag()
	EventBus.district_changed.emit(current_district)


func get_verb_availability() -> Dictionary:
	var availability: Dictionary = {}
	for verb: int in Verb.values():
		availability[verb] = _verb_state_for_cycle(verb, current_cycle)
	return availability


func get_cycle_opening_saturation_base() -> float:
	var index: int = clampi(current_cycle, CYCLE_MIN, EPILOGUE_CYCLE)
	return _CYCLE_OPENING_SATURATION[index]


## Manual save UI must call this before offering a slot (RULES.md café lock).
func can_manual_save() -> bool:
	return not is_cafe_scene


func _verb_state_for_cycle(verb: int, cycle: int) -> String:
	match verb:
		Verb.FORCER:
			if cycle >= 3:
				return "greyed"
			return "active"
		Verb.ABORDER:
			if cycle >= 3:
				return "greyed_some_npcs"
			return "active"
		Verb.EVITER:
			if cycle == 0:
				return "rare"
			return "active"
		Verb.CEDER:
			if cycle <= 1:
				return "hidden"
			return "active"
		Verb.RECULER:
			if cycle <= 1:
				return "low_utility"
			if cycle >= 3:
				return "forced_in_scenes"
			return "active"
		_:
			return "active"


func _trigger_autosave_stub() -> void:
	# ISSUE-407: persist GameFlags, inventory, saturation, player position.
	EventBus.game_saved.emit(AUTOSAVE_SLOT_ID)


func _sync_cafe_scene_flag() -> void:
	is_cafe_scene = current_district == DISTRICT_CAFE


func _is_valid_cycle(cycle: int) -> bool:
	return cycle >= CYCLE_MIN and cycle <= EPILOGUE_CYCLE
