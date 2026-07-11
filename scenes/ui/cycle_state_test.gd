extends Control
## Dev scene: verify CycleStateManager district order, cycles, autosave stub (ISSUE-103).

var _received_signals: PackedStringArray = PackedStringArray()

@onready var _status_label: Label = $VBox/StatusLabel
@onready var _verb_label: Label = $VBox/VerbLabel
@onready var _save_label: Label = $VBox/SaveLabel


func _ready() -> void:
	EventBus.district_changed.connect(_on_district_changed)
	EventBus.cycle_advanced.connect(_on_cycle_advanced)
	EventBus.game_saved.connect(_on_game_saved)

	$VBox/BootCycle0Button.pressed.connect(func() -> void: CycleStateManager.boot_dev_cycle(0))
	$VBox/BootCycle1Button.pressed.connect(func() -> void: CycleStateManager.boot_dev_cycle(1))
	$VBox/AdvanceDistrictButton.pressed.connect(_on_advance_district_pressed)
	$VBox/GoCafeButton.pressed.connect(func() -> void: CycleStateManager.set_district("cafe"))
	$VBox/LeaveCafeButton.pressed.connect(func() -> void: CycleStateManager.set_district("square"))

	_refresh()


func _on_advance_district_pressed() -> void:
	_received_signals = PackedStringArray()
	CycleStateManager.advance_district()
	_refresh()


func _on_district_changed(district_id: String) -> void:
	_received_signals.append("district_changed:%s" % district_id)
	_refresh()


func _on_cycle_advanced(new_cycle: int) -> void:
	_received_signals.append("cycle_advanced:%d" % new_cycle)
	_refresh()


func _on_game_saved(slot_id: int) -> void:
	_received_signals.append("game_saved:%d" % slot_id)
	_refresh()


func _refresh() -> void:
	_status_label.text = (
		"Cycle: %d | District: %s (%d) | Cafe scene: %s\nSaturation base: %.2f\nSignals: %s"
		% [
			CycleStateManager.current_cycle,
			CycleStateManager.current_district,
			CycleStateManager.district_index,
			CycleStateManager.is_cafe_scene,
			CycleStateManager.get_cycle_opening_saturation_base(),
			", ".join(_received_signals) if _received_signals.size() > 0 else "(none)",
		]
	)
	_save_label.text = "can_manual_save: %s" % CycleStateManager.can_manual_save()

	var verb_bits: PackedStringArray = PackedStringArray()
	for verb: int in CycleStateManager.Verb.values():
		verb_bits.append("%s=%s" % [CycleStateManager.Verb.keys()[verb], CycleStateManager.get_verb_availability()[verb]])
	_verb_label.text = "Verbs: " + ", ".join(verb_bits)
