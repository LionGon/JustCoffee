extends Node2D
## Dev scene: click-to-walk + dissociation freeze (ISSUE-205 acceptance).
## Default verb is GO. After OBSERVER (or any non-GO hotspot action), verb resets to GO.


const WALKABLE_RECT: Rect2 = Rect2(80.0, 520.0, 1760.0, 480.0)

@onready var _player: PlayerController = $Player
@onready var _status_label: Label = $UI/DebugPanel/VBox/StatusLabel
@onready var _verb_label: Label = $UI/DebugPanel/VBox/VerbLabel
@onready var _dissociation_label: Label = $UI/DebugPanel/VBox/DissociationLabel
@onready var _log_label: Label = $UI/DebugPanel/VBox/LogLabel

var _dissociation_active: bool = false


func _ready() -> void:
	EventBus.verb_selected.connect(_on_verb_selected)
	EventBus.dissociation_state_changed.connect(_on_dissociation_state_changed)
	EventBus.interactable_clicked.connect(_on_interactable_clicked)

	for hotspot: Node in $Hotspots.get_children():
		if hotspot is InteractableArea:
			var area: InteractableArea = hotspot as InteractableArea
			# Scene owns click routing via point query (avoids double-handling / false logs).
			area.input_pickable = false
			area.walk_to_requested.connect(_on_hotspot_walk_requested)
			area.interaction_attempted.connect(_on_hotspot_interaction_attempted)

	_select_go()
	print("[PlayerMovementTest] Click floor to walk. O = observe once, then back to GO. D = freeze.")


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		var key_event: InputEventKey = event as InputEventKey
		if key_event.keycode == KEY_D or key_event.physical_keycode == KEY_D:
			_toggle_dissociation()
			get_viewport().set_input_as_handled()
			return
		if key_event.keycode == KEY_O or key_event.physical_keycode == KEY_O:
			VerbSystem.select_verb(VerbSystem.Verb.OBSERVER, CycleStateManager.current_cycle)
			_refresh_ui()
			get_viewport().set_input_as_handled()
			return
		if key_event.keycode == KEY_G or key_event.physical_keycode == KEY_G:
			_select_go()
			get_viewport().set_input_as_handled()
			return

	if not event is InputEventMouseButton:
		return
	var mouse_event: InputEventMouseButton = event as InputEventMouseButton
	if not mouse_event.pressed or mouse_event.button_index != MOUSE_BUTTON_LEFT:
		return

	var click_pos: Vector2 = get_global_mouse_position()
	if not WALKABLE_RECT.has_point(click_pos):
		return

	if _player.is_frozen():
		_set_log("Frozen by dissociation (press D to unfreeze).")
		get_viewport().set_input_as_handled()
		return

	# Prefer hotspot under cursor (more reliable than Area2D alone under ColorRects).
	var hotspot: InteractableArea = _hotspot_at(click_pos)
	if hotspot != null:
		_handle_hotspot_click(hotspot)
		get_viewport().set_input_as_handled()
		return

	if VerbSystem.selected_verb == VerbSystem.Verb.ALLER:
		_player.walk_to(click_pos)
		_set_log("Walking to %s" % click_pos)
	# OBSERVER on empty ground: silent — wait for hotspot or press G.
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
		_set_log("Verb greyed — cannot use on '%s'" % hotspot.interactable_id)
		return
	if verb as int not in hotspot.enabled_verbs:
		_set_log("Verb not enabled on '%s'" % hotspot.interactable_id)
		return

	if verb == VerbSystem.Verb.ALLER:
		_player.walk_to(hotspot.global_position)
		EventBus.interactable_clicked.emit(hotspot.interactable_id)
		_set_log("GO → walk to '%s'" % hotspot.interactable_id)
		return

	# OBSERVER (and other non-GO verbs): interact in place, then snap back to GO.
	EventBus.interactable_clicked.emit(hotspot.interactable_id)
	_set_log(
		"%s → '%s' (verb resets to GO)"
		% [VerbSystem.get_label(verb, "en"), hotspot.interactable_id]
	)
	_select_go()


func _select_go() -> void:
	VerbSystem.select_verb(VerbSystem.Verb.ALLER, CycleStateManager.current_cycle)
	_refresh_ui()


func _on_hotspot_walk_requested(world_position: Vector2) -> void:
	# Area2D path (if it fires); keep in sync with point-query path.
	if VerbSystem.selected_verb == VerbSystem.Verb.ALLER:
		_player.walk_to(world_position)


func _on_hotspot_interaction_attempted(_id: String, _verb: int, _accepted: bool) -> void:
	pass


func _on_interactable_clicked(_interactable_id: String) -> void:
	# Logging is owned by _handle_hotspot_click / walk path to avoid duplicates.
	pass


func _on_verb_selected(_verb: int) -> void:
	_refresh_ui()


func _on_dissociation_state_changed(active: bool) -> void:
	_dissociation_active = active
	_refresh_ui()


func _toggle_dissociation() -> void:
	if _dissociation_active:
		SaturationManager.saturation_level = SaturationManager.DISSOCIATION_THRESHOLD - 0.05
	else:
		SaturationManager.saturation_level = SaturationManager.DISSOCIATION_THRESHOLD
	SaturationManager.apply_saturation()


func _refresh_ui() -> void:
	_verb_label.text = "Verb: %s" % VerbSystem.get_label(
		VerbSystem.selected_verb,
		LocalizationManager.get_locale(),
	)
	_dissociation_label.text = (
		"Dissociation: ACTIVE (movement frozen)"
		if _dissociation_active
		else "Dissociation: inactive"
	)
	_status_label.text = (
		"Moving"
		if _player.is_moving()
		else ("Frozen" if _player.is_frozen() else "Idle")
	)


func _process(_delta: float) -> void:
	_status_label.text = (
		"Moving"
		if _player.is_moving()
		else ("Frozen" if _player.is_frozen() else "Idle")
	)


func _set_log(message: String) -> void:
	_log_label.text = message
	print("[PlayerMovementTest] ", message)
