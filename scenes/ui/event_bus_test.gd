extends Control
## Dev scene: emit and receive every EventBus signal (ISSUE-101 acceptance).

var _received: PackedStringArray = PackedStringArray()
var _emit_button: Button


func _ready() -> void:
	_connect_all_signals()
	_emit_button = $VBox/EmitAllButton
	_emit_button.pressed.connect(_on_emit_all_pressed)
	_update_status_label()


func _connect_all_signals() -> void:
	EventBus.saturation_changed.connect(_on_saturation_changed)
	EventBus.verb_selected.connect(_on_verb_selected)
	EventBus.cycle_advanced.connect(_on_cycle_advanced)
	EventBus.district_changed.connect(_on_district_changed)
	EventBus.sanctuary_entered.connect(_on_sanctuary_entered)
	EventBus.reflection_mode_toggled.connect(_on_reflection_mode_toggled)
	EventBus.inner_monologue_triggered.connect(_on_inner_monologue_triggered)
	EventBus.interactable_clicked.connect(_on_interactable_clicked)
	EventBus.dialogue_started.connect(_on_dialogue_started)
	EventBus.dialogue_finished.connect(_on_dialogue_finished)
	EventBus.game_saved.connect(_on_game_saved)
	EventBus.dissociation_state_changed.connect(_on_dissociation_state_changed)


func _record(signal_name: String, args: Array = []) -> void:
	_received.append(signal_name)
	print("EventBus.%s received args=%s" % [signal_name, args])
	_update_status_label()


func _on_saturation_changed(new_level: float) -> void:
	_record("saturation_changed", [new_level])


func _on_verb_selected(verb: int) -> void:
	_record("verb_selected", [verb])


func _on_cycle_advanced(new_cycle: int) -> void:
	_record("cycle_advanced", [new_cycle])


func _on_district_changed(district_id: String) -> void:
	_record("district_changed", [district_id])


func _on_sanctuary_entered(sanctuary_id: String) -> void:
	_record("sanctuary_entered", [sanctuary_id])


func _on_reflection_mode_toggled(active: bool) -> void:
	_record("reflection_mode_toggled", [active])


func _on_inner_monologue_triggered(text_key: String) -> void:
	_record("inner_monologue_triggered", [text_key])


func _on_interactable_clicked(interactable_id: String) -> void:
	_record("interactable_clicked", [interactable_id])


func _on_dialogue_started(dialogue_id: String) -> void:
	_record("dialogue_started", [dialogue_id])


func _on_dialogue_finished(dialogue_id: String) -> void:
	_record("dialogue_finished", [dialogue_id])


func _on_game_saved(slot_id: int) -> void:
	_record("game_saved", [slot_id])


func _on_dissociation_state_changed(active: bool) -> void:
	_record("dissociation_state_changed", [active])


func _on_emit_all_pressed() -> void:
	_received = PackedStringArray()
	EventBus.saturation_changed.emit(0.5)
	EventBus.verb_selected.emit(0)
	EventBus.cycle_advanced.emit(1)
	EventBus.district_changed.emit("threshold")
	EventBus.sanctuary_entered.emit("bus_shelter")
	EventBus.reflection_mode_toggled.emit(true)
	EventBus.inner_monologue_triggered.emit("test.monologue")
	EventBus.interactable_clicked.emit("door_apartment")
	EventBus.dialogue_started.emit("cafe_beat_1")
	EventBus.dialogue_finished.emit("cafe_beat_1")
	EventBus.game_saved.emit(0)
	EventBus.dissociation_state_changed.emit(true)
	_update_status_label()


func _update_status_label() -> void:
	var status: Label = $VBox/StatusLabel
	status.text = "Received %d / 12 signals — check Output panel after Emit All" % _received.size()
