extends Node2D
## Manual verification scene for ISSUE-203 gaze interactions.
## Click routing mirrors ISSUE-205: point-query hotspots (Area2D pick is unreliable
## under ColorRects / overlapping cones). Default ALLER; non-GO resets to ALLER;
## empty-ground clicks only walk when ALLER is selected.


const MAX_LOG_LINES: int = 8
const PLAYER_SPEED: float = 360.0

@onready var _player: CharacterBody2D = $Player
@onready var _thomas_gaze: GazeVector = $Thomas/GazeVector
@onready var _kevin_gaze: GazeVector = $Kevin/GazeVector
@onready var _thomas_hotspot: InteractableArea = $Thomas/ThomasInteractable
@onready var _kevin_hotspot: InteractableArea = $Kevin/KevinInteractable
@onready var _status_label: Label = $UI/Panel/VBox/StatusLabel
@onready var _log_label: Label = $UI/Panel/VBox/LogScroll/LogLabel
@onready var _avoid_marker: Marker2D = $AvoidWaypoint
@onready var _avoid_line: Line2D = $AvoidLine

var _move_target: Vector2 = Vector2.INF
var _log_lines: PackedStringArray = PackedStringArray()


func _ready() -> void:
	EventBus.inner_monologue_triggered.connect(_on_inner_monologue_triggered)
	EventBus.dialogue_started.connect(_on_dialogue_started)
	EventBus.verb_selected.connect(_on_verb_selected)
	EventBus.interactable_clicked.connect(_on_interactable_clicked)
	$UI/Panel/VBox/VerbRow/GoButton.pressed.connect(_select_verb.bind(VerbSystem.Verb.ALLER))
	$UI/Panel/VBox/VerbRow/ObserverButton.pressed.connect(_select_verb.bind(VerbSystem.Verb.OBSERVER))
	$UI/Panel/VBox/VerbRow/AborderButton.pressed.connect(_select_verb.bind(VerbSystem.Verb.ABORDER))
	$UI/Panel/VBox/VerbRow/EcouterButton.pressed.connect(_select_verb.bind(VerbSystem.Verb.ECOUTER))
	$UI/Panel/VBox/VerbRow/EviterButton.pressed.connect(_select_verb.bind(VerbSystem.Verb.EVITER))
	$UI/Panel/VBox/PhoneButton.pressed.connect(_use_phone)

	# Scene owns click routing — avoid Area2D / Control fight with cone debug draw.
	for hotspot: InteractableArea in [_thomas_hotspot, _kevin_hotspot]:
		hotspot.input_pickable = false
	for label_path: NodePath in [
		^"Thomas/Name",
		^"Kevin/Name",
		^"Player/Label",
	]:
		var label: Label = get_node(label_path) as Label
		if label:
			label.mouse_filter = Control.MOUSE_FILTER_IGNORE

	_select_verb(VerbSystem.Verb.ALLER)
	_add_log("Click colored NPC bodies (not just the cone). ALLER walks; other verbs need a hotspot.")
	_refresh_ui()


func _process(_delta: float) -> void:
	_update_avoid_waypoint()
	_refresh_ui()


func _physics_process(_delta: float) -> void:
	var input_direction: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if input_direction != Vector2.ZERO:
		_move_target = Vector2.INF
		_player.velocity = input_direction * PLAYER_SPEED
	elif _move_target != Vector2.INF:
		var to_target: Vector2 = _move_target - _player.global_position
		if to_target.length() <= 6.0:
			_player.global_position = _move_target
			_move_target = Vector2.INF
			_player.velocity = Vector2.ZERO
		else:
			_player.velocity = to_target.normalized() * PLAYER_SPEED
	else:
		_player.velocity = Vector2.ZERO
	_player.move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if not event is InputEventMouseButton:
		return
	var mouse_event := event as InputEventMouseButton
	if mouse_event.button_index != MOUSE_BUTTON_LEFT or not mouse_event.pressed:
		return

	var click_pos: Vector2 = get_global_mouse_position()
	var hotspot: InteractableArea = _hotspot_at(click_pos)
	if hotspot != null:
		_handle_hotspot_click(hotspot)
		get_viewport().set_input_as_handled()
		return

	if VerbSystem.selected_verb == VerbSystem.Verb.ALLER:
		_move_target = click_pos
		_add_log("ALLER → walk")
	else:
		_add_log(
			"%s on empty ground — no walk (click the NPC body)"
			% VerbSystem.get_label(VerbSystem.selected_verb, "en")
		)
	get_viewport().set_input_as_handled()


func _hotspot_at(world_pos: Vector2) -> InteractableArea:
	var space: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	var query := PhysicsPointQueryParameters2D.new()
	query.position = world_pos
	query.collide_with_areas = true
	query.collide_with_bodies = false
	var hits: Array[Dictionary] = space.intersect_point(query, 16)
	for hit: Dictionary in hits:
		var collider: Object = hit.get("collider")
		if collider is InteractableArea:
			return collider as InteractableArea
	return null


func _handle_hotspot_click(hotspot: InteractableArea) -> void:
	var verb: VerbSystem.Verb = VerbSystem.selected_verb
	if VerbSystem.is_verb_greyed(verb, CycleStateManager.current_cycle):
		_add_log("Verb greyed on '%s'" % hotspot.interactable_id)
		return
	if verb as int not in hotspot.enabled_verbs:
		_add_log(
			"%s not enabled on '%s'"
			% [VerbSystem.get_label(verb, "en"), hotspot.interactable_id]
		)
		return

	# Emit for GazeVector listeners (same contract as InteractableArea).
	EventBus.interactable_clicked.emit(hotspot.interactable_id)


func _select_verb(verb: VerbSystem.Verb) -> void:
	VerbSystem.select_verb(verb, CycleStateManager.current_cycle)
	_add_log("Selected %s" % VerbSystem.get_label(verb, "en"))


func _use_phone() -> void:
	var used: bool = InventoryManager.use_item(InventoryManager.ITEM_PHONE_SCREEN_ON)
	_add_log("Phone use: %s" % ("active" if used else "unavailable"))


func _on_interactable_clicked(interactable_id: String) -> void:
	var verb: VerbSystem.Verb = VerbSystem.selected_verb
	_add_log("Hotspot '%s' with %s" % [interactable_id, VerbSystem.get_label(verb, "en")])
	if verb != VerbSystem.Verb.ALLER:
		call_deferred("_reset_to_aller")


func _reset_to_aller() -> void:
	VerbSystem.select_verb(VerbSystem.Verb.ALLER, CycleStateManager.current_cycle)


func _on_inner_monologue_triggered(text_key: String) -> void:
	_add_log("Monologue: %s" % LocalizationManager.get_text(text_key))


func _on_dialogue_started(dialogue_id: String) -> void:
	_add_log("Dialogue started: %s" % dialogue_id)


func _on_verb_selected(_verb: int) -> void:
	_refresh_ui()


func _update_avoid_waypoint() -> void:
	var active_gaze: GazeVector = _get_active_gaze()
	var should_show: bool = (
		VerbSystem.selected_verb == VerbSystem.Verb.EVITER
		and active_gaze != null
		and active_gaze.is_player_in_gaze()
	)
	_avoid_marker.visible = should_show
	_avoid_line.visible = should_show
	if not should_show:
		return
	_avoid_marker.global_position = active_gaze.get_avoid_waypoint()
	_avoid_line.points = PackedVector2Array([
		_player.global_position,
		_avoid_marker.global_position,
	])


func _get_active_gaze() -> GazeVector:
	if _thomas_gaze.is_player_in_gaze():
		return _thomas_gaze
	if _kevin_gaze.is_player_in_gaze():
		return _kevin_gaze
	return null


func _add_log(message: String) -> void:
	_log_lines.append(message)
	if _log_lines.size() > MAX_LOG_LINES:
		_log_lines = _log_lines.slice(_log_lines.size() - MAX_LOG_LINES)
	_log_label.text = "\n".join(_log_lines)
	print("[gaze_vector_test] %s" % message)


func _refresh_ui() -> void:
	var gaze_status: String = "Thomas=%s · Kevin=%s" % [
		str(_thomas_gaze.is_player_in_gaze()),
		str(_kevin_gaze.is_player_in_gaze()),
	]
	_status_label.text = (
		"Verb: %s · %s · phone blocks OBSERVER: %s · saturation: %.2f"
		% [
			VerbSystem.get_label(VerbSystem.selected_verb, "en"),
			gaze_status,
			str(InventoryManager.is_observer_gaze_blocked()),
			SaturationManager.saturation_level,
		]
	)
