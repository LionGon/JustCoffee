class_name PlayerController
extends CharacterBody2D
## Point-and-click protagonist movement (ISSUE-205).
## Simple walk-to-point with stiff placeholder motion; freezes during dissociation.


@export var walk_speed: float = 140.0
@export var arrival_threshold: float = 6.0
@export var walk_sway_degrees: float = 3.5
@export var walk_bob_pixels: float = 3.0

var _target_position: Vector2 = Vector2.INF
var _dissociation_frozen: bool = false
var _is_walking: bool = false
var _walk_phase: float = 0.0

@onready var _visual: Node2D = $Visual
@onready var _body: ColorRect = $Visual/Body


func _ready() -> void:
	EventBus.dissociation_state_changed.connect(_on_dissociation_state_changed)
	_sync_dissociation_from_saturation()
	_reset_walk_pose()


func _sync_dissociation_from_saturation() -> void:
	var threshold: float = SaturationManager.DISSOCIATION_THRESHOLD
	if SaturationManager.post_elena_state:
		threshold *= 0.9
	_on_dissociation_state_changed(SaturationManager.saturation_level >= threshold)


func _on_dissociation_state_changed(active: bool) -> void:
	_dissociation_frozen = active
	if active:
		cancel_walk()
		_reset_walk_pose()


func walk_to(world_position: Vector2) -> void:
	if _dissociation_frozen:
		return
	_target_position = world_position


func cancel_walk() -> void:
	_target_position = Vector2.INF
	velocity = Vector2.ZERO
	_set_walking(false)


func is_moving() -> bool:
	return _is_walking


func is_frozen() -> bool:
	return _dissociation_frozen


func _physics_process(delta: float) -> void:
	if _dissociation_frozen:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	if _target_position == Vector2.INF:
		velocity = Vector2.ZERO
		_set_walking(false)
		move_and_slide()
		return

	var to_target: Vector2 = _target_position - global_position
	var distance: float = to_target.length()
	if distance <= arrival_threshold:
		global_position = _target_position
		cancel_walk()
		move_and_slide()
		return

	var direction: Vector2 = to_target / distance
	velocity = direction * walk_speed
	move_and_slide()
	_set_walking(true)
	_apply_stiff_walk_motion(delta, direction)


func _set_walking(walking: bool) -> void:
	if walking == _is_walking:
		return
	_is_walking = walking
	if not walking:
		_reset_walk_pose()


func _apply_stiff_walk_motion(delta: float, direction: Vector2) -> void:
	_walk_phase += delta * 9.0
	var sway: float = deg_to_rad(walk_sway_degrees) * sin(_walk_phase * 2.0)
	_visual.rotation = sway
	_body.position.y = abs(sin(_walk_phase)) * walk_bob_pixels
	if absf(direction.x) > 0.05:
		_visual.scale.x = -1.0 if direction.x < 0.0 else 1.0


func _reset_walk_pose() -> void:
	_walk_phase = 0.0
	if _visual:
		_visual.rotation = 0.0
		_visual.scale.x = 1.0
	if _body:
		_body.position.y = 0.0
