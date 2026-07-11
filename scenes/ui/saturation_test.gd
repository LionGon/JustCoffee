extends Control
## Dev scene: keyboard saturation adjustment (ISSUE-104 acceptance).

@onready var _status_label: Label = $VBox/StatusLabel
@onready var _dissociation_label: Label = $VBox/DissociationLabel
@onready var _hint_label: Label = $VBox/HintLabel

var _dissociation_active: bool = false
var _last_action: String = ""


func _ready() -> void:
	EventBus.dissociation_state_changed.connect(_on_dissociation_state_changed)
	_refresh_labels()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		var key_event: InputEventKey = event as InputEventKey
		var physical: Key = key_event.physical_keycode
		var logical: Key = key_event.keycode
		# Layout-independent bindings (AZERTY: digits need Shift and often miss KEY_0/KEY_1).
		if _is_increase_key(physical, logical):
			SaturationManager.add_saturation(0.05, "debug_keyboard")
			_last_action = "Added +0.05"
			_refresh_labels()
		elif _is_decrease_key(physical, logical):
			SaturationManager.reduce_saturation(0.05, "debug_keyboard")
			_last_action = "Reduced −0.05"
			_refresh_labels()
		elif physical == KEY_P or logical == KEY_P:
			SaturationManager.set_post_elena_state(not SaturationManager.post_elena_state)
			_last_action = "Toggled post-Elena"
			_refresh_labels()
		elif physical == KEY_F9 or logical == KEY_F9:
			var before: float = SaturationManager.saturation_level
			SaturationManager.apply_cycle_opening_reset(0)
			_last_action = "Cycle 0 reset: %.2f → %.2f" % [before, SaturationManager.saturation_level]
			_refresh_labels()
		elif physical == KEY_F10 or logical == KEY_F10:
			var before: float = SaturationManager.saturation_level
			SaturationManager.apply_cycle_opening_reset(1)
			_last_action = "Cycle 1 reset: %.2f → %.2f" % [before, SaturationManager.saturation_level]
			_refresh_labels()


func _is_increase_key(physical: Key, logical: Key) -> bool:
	return physical in [KEY_EQUAL, KEY_KP_ADD, KEY_BRACKETRIGHT, KEY_UP] \
		or logical in [KEY_EQUAL, KEY_KP_ADD, KEY_BRACKETRIGHT, KEY_UP]


func _is_decrease_key(physical: Key, logical: Key) -> bool:
	return physical in [KEY_MINUS, KEY_KP_SUBTRACT, KEY_BRACKETLEFT, KEY_DOWN] \
		or logical in [KEY_MINUS, KEY_KP_SUBTRACT, KEY_BRACKETLEFT, KEY_DOWN]


func _on_dissociation_state_changed(active: bool) -> void:
	_dissociation_active = active
	_refresh_labels()


func _effective_threshold() -> float:
	var threshold: float = SaturationManager.DISSOCIATION_THRESHOLD
	if SaturationManager.post_elena_state:
		threshold *= 0.9
	return threshold


func _refresh_labels() -> void:
	_status_label.text = (
		"Dev only — level %.2f | post_elena=%s | threshold %.2f\n%s"
		% [
			SaturationManager.saturation_level,
			SaturationManager.post_elena_state,
			_effective_threshold(),
			_last_action,
		]
	)
	_dissociation_label.text = (
		"Dissociation: ACTIVE (≥ %.2f)" % _effective_threshold()
		if _dissociation_active
		else "Dissociation: inactive (needs ≥ %.2f)" % _effective_threshold()
	)
	_hint_label.text = (
		"↑/↓ or +/- : adjust · P : post-Elena · F9 : cycle 0 reset · F10 : cycle 1 reset"
	)
