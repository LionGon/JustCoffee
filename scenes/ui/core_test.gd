extends Control
## Dev scene: all M1 autoloads wired through EventBus (ISSUE-108 acceptance).

const SATURATION_STEP: float = 0.1
const MAX_LOG_LINES: int = 14

@onready var _state_label: Label = $Scroll/VBox/StateLabel
@onready var _saturation_label: Label = $Scroll/VBox/SaturationLabel
@onready var _dissociation_label: Label = $Scroll/VBox/DissociationLabel
@onready var _reflection_mode_label: Label = $Scroll/VBox/ReflectionModeLabel
@onready var _event_log_label: Label = $Scroll/VBox/EventLogLabel
@onready var _verb_grid: GridContainer = $Scroll/VBox/VerbGrid

var _dissociation_active: bool = false
var _event_log: PackedStringArray = PackedStringArray()


func _ready() -> void:
	_connect_event_bus()
	_build_verb_buttons()

	$Scroll/VBox/Controls/SatRow/SatPlusButton.pressed.connect(_on_sat_plus_pressed)
	$Scroll/VBox/Controls/SatRow/SatMinusButton.pressed.connect(_on_sat_minus_pressed)
	$Scroll/VBox/Controls/DistrictRow/NextDistrictButton.pressed.connect(_on_next_district_pressed)
	$Scroll/VBox/Controls/DistrictRow/Cycle0Button.pressed.connect(func() -> void: _boot_cycle(0))
	$Scroll/VBox/Controls/DistrictRow/Cycle1Button.pressed.connect(func() -> void: _boot_cycle(1))
	$Scroll/VBox/Controls/ExtraRow/ToggleLocaleButton.pressed.connect(_on_toggle_locale_pressed)
	$Scroll/VBox/Controls/ExtraRow/UsePhoneButton.pressed.connect(_on_use_phone_pressed)
	$Scroll/VBox/Controls/ExtraRow/ToggleElenaFlagButton.pressed.connect(_on_toggle_elena_flag_pressed)
	$Scroll/VBox/Controls/ReflectionRow/ReflectionModeButton.pressed.connect(_on_reflection_mode_pressed)
	$Scroll/VBox/Controls/ReflectionRow/ForceReflectionCycle1Button.pressed.connect(
		_on_force_reflection_cycle_1_pressed
	)

	_refresh()


func _connect_event_bus() -> void:
	EventBus.saturation_changed.connect(_on_saturation_changed)
	EventBus.verb_selected.connect(_on_verb_selected)
	EventBus.cycle_advanced.connect(_on_cycle_advanced)
	EventBus.district_changed.connect(_on_district_changed)
	EventBus.sanctuary_entered.connect(_on_sanctuary_entered)
	EventBus.game_saved.connect(_on_game_saved)
	EventBus.dissociation_state_changed.connect(_on_dissociation_state_changed)
	EventBus.reflection_mode_toggled.connect(_on_reflection_mode_toggled)


func _build_verb_buttons() -> void:
	for verb: VerbSystem.Verb in VerbSystem.get_all_verbs():
		var button := Button.new()
		button.text = VerbSystem.get_label(verb, LocalizationManager.get_locale())
		button.pressed.connect(_on_verb_button_pressed.bind(verb))
		_verb_grid.add_child(button)


func _on_sat_plus_pressed() -> void:
	SaturationManager.add_saturation(SATURATION_STEP, "core_test")


func _on_sat_minus_pressed() -> void:
	SaturationManager.reduce_saturation(SATURATION_STEP, "core_test")


func _on_next_district_pressed() -> void:
	CycleStateManager.advance_district()


func _on_force_reflection_cycle_1_pressed() -> void:
	GameFlags.set_flag(ReflectionMode.DEV_FORCE_ENABLE_FLAG, true)
	ReflectionMode.set_active(true)
	_log_action("dev_reflection_mode_force → true; set_active(true)")


func _boot_cycle(cycle: int) -> void:
	# Clear force so Cycle 1 lock can be retested cleanly.
	GameFlags.set_flag(ReflectionMode.DEV_FORCE_ENABLE_FLAG, false)
	CycleStateManager.boot_dev_cycle(cycle)
	SaturationManager.apply_cycle_opening_reset(cycle)
	if cycle == 1 and ReflectionMode.is_active():
		ReflectionMode.set_active(false)
	_log_action("boot cycle %d (force flag cleared)" % cycle)


func _on_toggle_locale_pressed() -> void:
	var next_locale: String = "en" if LocalizationManager.get_locale() == "fr" else "fr"
	LocalizationManager.set_locale(next_locale)
	_update_verb_button_labels()
	_log_action("locale → %s" % next_locale)


func _on_use_phone_pressed() -> void:
	var ok: bool = InventoryManager.use_item(InventoryManager.ITEM_PHONE_SCREEN_ON)
	_log_action("phone item: %s" % ("used" if ok else "failed"))


func _on_toggle_elena_flag_pressed() -> void:
	var current: bool = GameFlags.get_flag(GameFlags.FLAG_ELENA_GAZE_COMPLETE, false) as bool
	GameFlags.set_flag(GameFlags.FLAG_ELENA_GAZE_COMPLETE, not current)
	_log_action("elena_gaze_complete → %s" % str(not current))


func _on_reflection_mode_pressed() -> void:
	ReflectionMode.toggle()


func _on_verb_button_pressed(verb: VerbSystem.Verb) -> void:
	var context: Dictionary = {}
	VerbSystem.select_verb(verb, CycleStateManager.current_cycle, context)


func _update_verb_button_labels() -> void:
	var locale: String = LocalizationManager.get_locale()
	var index: int = 0
	for verb: VerbSystem.Verb in VerbSystem.get_all_verbs():
		if index >= _verb_grid.get_child_count():
			break
		var button: Button = _verb_grid.get_child(index) as Button
		if button != null:
			button.text = VerbSystem.get_label(verb, locale)
		index += 1


func _on_saturation_changed(new_level: float) -> void:
	_record_event("saturation_changed", [new_level])


func _on_verb_selected(verb: int) -> void:
	_record_event("verb_selected", [verb])


func _on_cycle_advanced(new_cycle: int) -> void:
	_record_event("cycle_advanced", [new_cycle])


func _on_district_changed(district_id: String) -> void:
	_record_event("district_changed", [district_id])


func _on_sanctuary_entered(sanctuary_id: String) -> void:
	_record_event("sanctuary_entered", [sanctuary_id])


func _on_game_saved(slot_id: int) -> void:
	_record_event("game_saved", [slot_id])


func _on_dissociation_state_changed(active: bool) -> void:
	_dissociation_active = active
	_record_event("dissociation_state_changed", [active])


func _on_reflection_mode_toggled(active: bool) -> void:
	_record_event("reflection_mode_toggled", [active])


func _record_event(signal_name: String, args: Array = []) -> void:
	var line: String = "EventBus.%s %s" % [signal_name, args]
	_event_log.append(line)
	if _event_log.size() > MAX_LOG_LINES:
		_event_log = _event_log.slice(_event_log.size() - MAX_LOG_LINES)
	print(line)
	_refresh_event_log()
	_refresh()


func _log_action(message: String) -> void:
	_event_log.append("[action] %s" % message)
	if _event_log.size() > MAX_LOG_LINES:
		_event_log = _event_log.slice(_event_log.size() - MAX_LOG_LINES)
	print("[core_test] %s" % message)
	_refresh_event_log()
	_refresh()


func _refresh_event_log() -> void:
	_event_log_label.text = (
		"EventBus log (dev):\n%s"
		% ("\n".join(_event_log) if _event_log.size() > 0 else "(no events yet)")
	)


func _effective_dissociation_threshold() -> float:
	var threshold: float = SaturationManager.DISSOCIATION_THRESHOLD
	if SaturationManager.post_elena_state:
		threshold *= 0.9
	return threshold


func _refresh() -> void:
	_state_label.text = (
		"Cycle %d · District %s (%d) · cafe=%s · locale %s\n"
		% [
			CycleStateManager.current_cycle,
			CycleStateManager.current_district,
			CycleStateManager.district_index,
			CycleStateManager.is_cafe_scene,
			LocalizationManager.get_locale(),
		]
		+ "observer_gaze_blocked=%s · elena_gaze=%s · can_save=%s"
		% [
			InventoryManager.is_observer_gaze_blocked(),
			GameFlags.get_flag(GameFlags.FLAG_ELENA_GAZE_COMPLETE, false),
			CycleStateManager.can_manual_save(),
		]
	)
	_saturation_label.text = (
		"Dev only — saturation %.2f (post_elena=%s)"
		% [SaturationManager.saturation_level, SaturationManager.post_elena_state]
	)
	_dissociation_label.text = (
		"Dissociation: ACTIVE (≥ %.2f)"
		if _dissociation_active
		else "Dissociation: inactive — raise saturation to ≥ %.2f"
	) % _effective_dissociation_threshold()
	_reflection_mode_label.text = (
		"Reflection Mode: %s · Cycle 1 dev force=%s"
		% [
			"ACTIVE" if ReflectionMode.is_active() else "inactive",
			GameFlags.get_flag(ReflectionMode.DEV_FORCE_ENABLE_FLAG, false),
		]
	)
