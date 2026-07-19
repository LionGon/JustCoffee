class_name GazeVector
extends Area2D
## Dynamic NPC gaze cone for OBSERVER and verb-specific gaze interactions.
##
## ÉVITER hook (ISSUE-203): PlayerController / nav mesh should call
## `get_avoid_waypoint()` when VerbSystem.selected_verb == EVITER and
## `is_player_in_gaze()`. Full NavigationAgent2D wiring is optional for VS.
##
## ISSUE-204 will bind these local states to the NPC state machine.


enum GazeState {
	SCANNING,
	LOCKED_ON,
	IDLE,
}

@export var npc_id: String = ""
@export var interactable_id: String = ""
@export_range(32.0, 1200.0, 1.0) var cone_length: float = 280.0:
	set(value):
		cone_length = value
		_rebuild_cone()
@export_range(1.0, 89.0, 0.5) var cone_half_angle_deg: float = 28.0:
	set(value):
		cone_half_angle_deg = value
		_rebuild_cone()
@export var initial_state: GazeState = GazeState.SCANNING:
	set(value):
		if _is_valid_state(value):
			initial_state = value

var gaze_state: GazeState = GazeState.SCANNING:
	set(value):
		if not _is_valid_state(value):
			push_warning("GazeVector: invalid gaze state %s" % value)
			return
		gaze_state = value

var _player_in_cone: bool = false
var _headphones_jitter_elapsed: float = 0.0
var _headphones_angle_multiplier: float = 1.0
var _cone_collision: CollisionPolygon2D
var _debug_fill: Polygon2D
var _debug_outline: Line2D

@export var debug_draw_cone: bool = false
@export var debug_cone_color: Color = Color(1.0, 0.85, 0.2, 0.35)


func _ready() -> void:
	monitoring = true
	monitorable = true
	input_pickable = false  # Cone detects bodies only — never steal hotspot clicks
	collision_layer = 0
	collision_mask = 1  # Default CharacterBody2D layer
	gaze_state = initial_state
	_cone_collision = _get_or_create_collision_polygon()
	_ensure_debug_visuals()
	_rebuild_cone()
	EventBus.interactable_clicked.connect(_on_interactable_clicked)


func _physics_process(_delta: float) -> void:
	# Poll overlap each physics frame — body_entered/exited flickers on polygon edges.
	_player_in_cone = false
	for body: Node2D in get_overlapping_bodies():
		if body.is_in_group("player"):
			_player_in_cone = true
			break


func _process(delta: float) -> void:
	if not GameFlags.get_flag(InventoryManager.FLAG_HEADPHONES_ACTIVE, false):
		if _headphones_angle_multiplier != 1.0:
			_headphones_angle_multiplier = 1.0
			_rebuild_cone()
		_headphones_jitter_elapsed = 0.0
		return

	_headphones_jitter_elapsed += delta
	if _headphones_jitter_elapsed < 1.0:
		return
	_headphones_jitter_elapsed = 0.0
	_headphones_angle_multiplier = randf_range(0.5, 1.5)
	_rebuild_cone()


func get_gaze_text_key(cycle: int) -> String:
	return "gaze_%s_cycle_%d" % [npc_id, cycle]


func is_player_in_gaze() -> bool:
	return _player_in_cone


func get_avoid_waypoint() -> Vector2:
	var forward: Vector2 = Vector2.RIGHT.rotated(global_rotation)
	var perpendicular: Vector2 = forward.rotated(PI * 0.5)
	return global_position + forward * (cone_length * 0.5) + perpendicular * (cone_length * 0.5)


func _on_interactable_clicked(clicked_interactable_id: String) -> void:
	if clicked_interactable_id != interactable_id:
		return

	var verb: VerbSystem.Verb = VerbSystem.selected_verb
	match verb:
		VerbSystem.Verb.OBSERVER:
			_handle_observer()
		VerbSystem.Verb.ABORDER:
			SaturationManager.add_saturation(0.08, "aborder_gaze")
			EventBus.dialogue_started.emit("%s_approach" % npc_id)
		VerbSystem.Verb.ECOUTER:
			SaturationManager.add_saturation(0.03, "ecouter_gaze")
		VerbSystem.Verb.EVITER:
			# PlayerController/navigation consumes get_avoid_waypoint() when in gaze.
			pass
		_:
			pass


func _handle_observer() -> void:
	if InventoryManager.is_observer_gaze_blocked():
		EventBus.inner_monologue_triggered.emit("gaze_blocked_by_phone")
		return
	EventBus.inner_monologue_triggered.emit(get_gaze_text_key(CycleStateManager.current_cycle))


func _get_or_create_collision_polygon() -> CollisionPolygon2D:
	for child: Node in get_children():
		if child is CollisionPolygon2D:
			return child as CollisionPolygon2D
	var collision_polygon := CollisionPolygon2D.new()
	collision_polygon.name = "CollisionPolygon2D"
	add_child(collision_polygon)
	return collision_polygon


func _ensure_debug_visuals() -> void:
	_debug_fill = get_node_or_null("DebugConeFill") as Polygon2D
	if _debug_fill == null:
		_debug_fill = Polygon2D.new()
		_debug_fill.name = "DebugConeFill"
		_debug_fill.z_index = 10
		add_child(_debug_fill)
	_debug_outline = get_node_or_null("DebugConeOutline") as Line2D
	if _debug_outline == null:
		_debug_outline = Line2D.new()
		_debug_outline.name = "DebugConeOutline"
		_debug_outline.z_index = 11
		_debug_outline.width = 3.0
		_debug_outline.closed = true
		add_child(_debug_outline)
	_update_debug_visual_visibility()


func _update_debug_visual_visibility() -> void:
	if _debug_fill:
		_debug_fill.visible = debug_draw_cone
		_debug_fill.color = debug_cone_color
	if _debug_outline:
		_debug_outline.visible = debug_draw_cone
		_debug_outline.default_color = Color(
			debug_cone_color.r,
			debug_cone_color.g,
			debug_cone_color.b,
			minf(1.0, debug_cone_color.a + 0.45)
		)


func _rebuild_cone() -> void:
	if not is_instance_valid(_cone_collision):
		return
	var angle: float = deg_to_rad(cone_half_angle_deg * _headphones_angle_multiplier)
	var upper: Vector2 = Vector2.RIGHT.rotated(-angle) * cone_length
	var lower: Vector2 = Vector2.RIGHT.rotated(angle) * cone_length
	var points: PackedVector2Array = PackedVector2Array([Vector2.ZERO, upper, lower])
	_cone_collision.polygon = points
	if _debug_fill:
		_debug_fill.polygon = points
	if _debug_outline:
		_debug_outline.points = points
	_update_debug_visual_visibility()


func _is_valid_state(value: int) -> bool:
	return value >= GazeState.SCANNING and value <= GazeState.IDLE
