class_name NpcStateMachine
extends Node
## FSM for all NPC behavior — no if/else chains (ISSUE-204 / RULES.md §13).
## Transitions are driven by signals and exported data, never by dialogue text.
##
## FSM diagram:
## ```
##                      ┌──────────────┐
##            ┌────────►│   SCANNING   │◄────────┐
##            │         └──────┬───────┘         │
##            │                │                 │
##            │                ▼                 │
##       ┌────┴───┐      ┌───────────┐     ┌─────┴────────┐
##       │  IDLE  │◄────►│ LOCKED_ON │────►│HOSTILE_LATENT│
##       └───┬────┘      └─────┬─────┘     └──────┬───────┘
##           │                 │                  │
##           │                 └──────────────────┘
##           │              (hostile never gets a
##           │               distinct visual tell —
##           │               animation stays mechanical)
##      ┌────┴─────┬──────────────┐
##      ▼          ▼              │
## BENEVOLENT  COMPLICIT          │
## (grocery    (Marc / barista)   │
##  Cycle 1+)                     │
##      │          │              │
##      └────► IDLE ◄─────────────┘
## ```
##
## Role defaults:
## - Marc → COMPLICIT (café scene setup)
## - Grocery shopkeeper → BENEVOLENT when cycle >= 1


enum NPCState {
	IDLE,
	SCANNING,
	LOCKED_ON,
	HOSTILE_LATENT,
	BENEVOLENT,
	COMPLICIT,
}

## Animation profile exposed to marionette / audio systems (ISSUE-607).
enum AnimationProfile {
	MECHANICAL, ## Hostile / neutral / complicit — never a threat tell (§9).
	WARMER, ## Benevolent only — sole visual signal of safety (§9).
}

signal state_changed(from_state: NPCState, to_state: NPCState)
signal transition_rejected(from_state: NPCState, to_state: NPCState)

## Allowed edges: from_state → Array[to_state]. Self-transitions are always rejected.
const VALID_TRANSITIONS: Dictionary = {
	NPCState.IDLE: [
		NPCState.SCANNING,
		NPCState.LOCKED_ON,
		NPCState.HOSTILE_LATENT,
		NPCState.BENEVOLENT,
		NPCState.COMPLICIT,
	],
	NPCState.SCANNING: [
		NPCState.IDLE,
		NPCState.LOCKED_ON,
		NPCState.HOSTILE_LATENT,
	],
	NPCState.LOCKED_ON: [
		NPCState.IDLE,
		NPCState.SCANNING,
		NPCState.HOSTILE_LATENT,
	],
	NPCState.HOSTILE_LATENT: [
		NPCState.IDLE,
		NPCState.SCANNING,
	],
	NPCState.BENEVOLENT: [
		NPCState.IDLE,
	],
	NPCState.COMPLICIT: [
		NPCState.IDLE,
	],
}

const ANIMATION_BY_STATE: Dictionary = {
	NPCState.IDLE: AnimationProfile.MECHANICAL,
	NPCState.SCANNING: AnimationProfile.MECHANICAL,
	NPCState.LOCKED_ON: AnimationProfile.MECHANICAL,
	NPCState.HOSTILE_LATENT: AnimationProfile.MECHANICAL,
	NPCState.BENEVOLENT: AnimationProfile.WARMER,
	NPCState.COMPLICIT: AnimationProfile.MECHANICAL,
}

@export var npc_id: String = ""
@export var initial_state: NPCState = NPCState.IDLE:
	set(value):
		if not _is_defined_state(value):
			push_warning("NpcStateMachine(%s): invalid initial_state %s" % [npc_id, value])
			return
		initial_state = value

## Optional sibling/child GazeVector to keep in sync for SCANNING / LOCKED_ON / IDLE.
@export var gaze_vector_path: NodePath = NodePath("")

## When true, CycleStateManager.cycle_advanced drives shopkeeper BENEVOLENT (Cycle 1+).
@export var apply_shopkeeper_benevolent_by_cycle: bool = false

var current_state: NPCState = NPCState.IDLE:
	set(value):
		# Direct assignment is reserved for boot / forced reset — prefer transition_to().
		if not _is_defined_state(value):
			push_warning("NpcStateMachine(%s): invalid current_state %s" % [npc_id, value])
			return
		current_state = value

var _gaze_vector: GazeVector = null


func _ready() -> void:
	_resolve_gaze_vector()
	_enter_initial_state()
	if apply_shopkeeper_benevolent_by_cycle:
		EventBus.cycle_advanced.connect(_on_cycle_advanced)
		_apply_shopkeeper_for_cycle(CycleStateManager.current_cycle)


func _exit_tree() -> void:
	if EventBus.cycle_advanced.is_connected(_on_cycle_advanced):
		EventBus.cycle_advanced.disconnect(_on_cycle_advanced)


## Attempt a legal transition. Returns true on success; rejects and warns otherwise.
func transition_to(next_state: NPCState) -> bool:
	if not _is_defined_state(next_state):
		push_warning(
			"NpcStateMachine(%s): rejected undefined state %s" % [npc_id, next_state]
		)
		transition_rejected.emit(current_state, next_state)
		return false
	if next_state == current_state:
		push_warning(
			"NpcStateMachine(%s): rejected self-transition %s" % [npc_id, _state_name(next_state)]
		)
		transition_rejected.emit(current_state, next_state)
		return false
	if not can_transition_to(next_state):
		push_warning(
			"NpcStateMachine(%s): rejected %s → %s"
			% [npc_id, _state_name(current_state), _state_name(next_state)]
		)
		transition_rejected.emit(current_state, next_state)
		return false

	var previous: NPCState = current_state
	current_state = next_state
	_sync_gaze_vector(next_state)
	state_changed.emit(previous, next_state)
	return true


## True if `next_state` is a legal edge from `current_state` (not including self).
func can_transition_to(next_state: NPCState) -> bool:
	if not _is_defined_state(next_state):
		return false
	if next_state == current_state:
		return false
	var allowed: Variant = VALID_TRANSITIONS.get(current_state, [])
	return next_state in (allowed as Array)


## Animation profile for the active state. HOSTILE_LATENT is always mechanical (§9).
func get_animation_profile() -> AnimationProfile:
	return ANIMATION_BY_STATE.get(current_state, AnimationProfile.MECHANICAL) as AnimationProfile


## Hostile / scanning / complicit NPCs never look warmer than mechanical.
func is_animation_mechanical() -> bool:
	return get_animation_profile() == AnimationProfile.MECHANICAL


## Convenience for café / district setup scripts (Marc COMPLICIT, shopkeeper BENEVOLENT).
func force_role_state(role_state: NPCState) -> bool:
	const ROLE_STATES: Array[int] = [
		NPCState.IDLE,
		NPCState.HOSTILE_LATENT,
		NPCState.BENEVOLENT,
		NPCState.COMPLICIT,
	]
	if role_state as int not in ROLE_STATES:
		push_warning(
			"NpcStateMachine(%s): force_role_state only accepts role/IDLE states, got %s"
			% [npc_id, _state_name(role_state)]
		)
		return false
	if current_state == role_state:
		return true
	if can_transition_to(role_state):
		return transition_to(role_state)
	# Leave disposition / latent via IDLE, then enter the requested role.
	if current_state != NPCState.IDLE:
		if not transition_to(NPCState.IDLE):
			return false
	if role_state == NPCState.IDLE:
		return true
	return transition_to(role_state)


## Grocery shopkeeper: BENEVOLENT from Cycle 1 onward; IDLE in Cycle 0.
func apply_shopkeeper_for_cycle(cycle: int) -> bool:
	return _apply_shopkeeper_for_cycle(cycle)


func get_state_name(state: NPCState = current_state) -> String:
	return _state_name(state)


func _enter_initial_state() -> void:
	current_state = initial_state
	_sync_gaze_vector(current_state)


func _resolve_gaze_vector() -> void:
	if gaze_vector_path != NodePath(""):
		_gaze_vector = get_node_or_null(gaze_vector_path) as GazeVector
		return
	# Prefer an explicit child named GazeVector, then any sibling.
	_gaze_vector = get_node_or_null("GazeVector") as GazeVector
	if _gaze_vector != null:
		return
	var parent_node: Node = get_parent()
	if parent_node == null:
		return
	_gaze_vector = parent_node.get_node_or_null("GazeVector") as GazeVector


func _sync_gaze_vector(state: NPCState) -> void:
	if _gaze_vector == null:
		return
	match state:
		NPCState.IDLE:
			_gaze_vector.gaze_state = GazeVector.GazeState.IDLE
		NPCState.SCANNING:
			_gaze_vector.gaze_state = GazeVector.GazeState.SCANNING
		NPCState.LOCKED_ON:
			_gaze_vector.gaze_state = GazeVector.GazeState.LOCKED_ON
		NPCState.HOSTILE_LATENT, NPCState.BENEVOLENT, NPCState.COMPLICIT:
			# Disposition states keep gaze idle — hostility must not be visually coded.
			_gaze_vector.gaze_state = GazeVector.GazeState.IDLE
		_:
			pass


func _on_cycle_advanced(new_cycle: int) -> void:
	_apply_shopkeeper_for_cycle(new_cycle)


func _apply_shopkeeper_for_cycle(cycle: int) -> bool:
	var target: NPCState = NPCState.BENEVOLENT if cycle >= 1 else NPCState.IDLE
	if current_state == target:
		return true
	if can_transition_to(target):
		return transition_to(target)
	# Gaze / hostile states reach BENEVOLENT via IDLE.
	if target == NPCState.BENEVOLENT:
		if current_state != NPCState.IDLE and not transition_to(NPCState.IDLE):
			return false
		return transition_to(NPCState.BENEVOLENT)
	return false


func _is_defined_state(value: int) -> bool:
	return value >= NPCState.IDLE and value <= NPCState.COMPLICIT


func _state_name(state: NPCState) -> String:
	match state:
		NPCState.IDLE:
			return "IDLE"
		NPCState.SCANNING:
			return "SCANNING"
		NPCState.LOCKED_ON:
			return "LOCKED_ON"
		NPCState.HOSTILE_LATENT:
			return "HOSTILE_LATENT"
		NPCState.BENEVOLENT:
			return "BENEVOLENT"
		NPCState.COMPLICIT:
			return "COMPLICIT"
		_:
			return "UNKNOWN(%d)" % state
