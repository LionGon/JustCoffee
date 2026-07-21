extends Node2D
## Manual verification for ISSUE-204 NPC FSM: transitions, rejects, animation profile.


const MAX_LOG_LINES: int = 10

@onready var _observer_fsm: NpcStateMachine = $Observer/NpcStateMachine
@onready var _marc_fsm: NpcStateMachine = $Marc/NpcStateMachine
@onready var _shopkeeper_fsm: NpcStateMachine = $Shopkeeper/NpcStateMachine
@onready var _status_label: Label = $UI/Panel/VBox/StatusLabel
@onready var _log_label: Label = $UI/Panel/VBox/LogScroll/LogLabel

var _log_lines: PackedStringArray = PackedStringArray()


func _ready() -> void:
	_observer_fsm.state_changed.connect(_on_state_changed.bind("observer"))
	_observer_fsm.transition_rejected.connect(_on_transition_rejected.bind("observer"))
	_marc_fsm.state_changed.connect(_on_state_changed.bind("marc"))
	_marc_fsm.transition_rejected.connect(_on_transition_rejected.bind("marc"))
	_shopkeeper_fsm.state_changed.connect(_on_state_changed.bind("shopkeeper"))
	_shopkeeper_fsm.transition_rejected.connect(_on_transition_rejected.bind("shopkeeper"))

	$UI/Panel/VBox/ObserverRow/IdleButton.pressed.connect(
		_try_observer.bind(NpcStateMachine.NPCState.IDLE)
	)
	$UI/Panel/VBox/ObserverRow/ScanButton.pressed.connect(
		_try_observer.bind(NpcStateMachine.NPCState.SCANNING)
	)
	$UI/Panel/VBox/ObserverRow/LockButton.pressed.connect(
		_try_observer.bind(NpcStateMachine.NPCState.LOCKED_ON)
	)
	$UI/Panel/VBox/ObserverRow/HostileButton.pressed.connect(
		_try_observer.bind(NpcStateMachine.NPCState.HOSTILE_LATENT)
	)
	$UI/Panel/VBox/ObserverRow/BenevolentInvalidButton.pressed.connect(
		_try_observer.bind(NpcStateMachine.NPCState.BENEVOLENT)
	)
	$UI/Panel/VBox/RoleRow/Cycle0Button.pressed.connect(_set_shopkeeper_cycle.bind(0))
	$UI/Panel/VBox/RoleRow/Cycle1Button.pressed.connect(_set_shopkeeper_cycle.bind(1))
	$UI/Panel/VBox/RoleRow/MarcComplicitButton.pressed.connect(_assert_marc_complicit)

	_add_log(
		"Marc boot state=%s (expect COMPLICIT). Try invalid SCANNING→BENEVOLENT."
		% _marc_fsm.get_state_name()
	)
	_refresh_status()


func _try_observer(next_state: NpcStateMachine.NPCState) -> void:
	var from_name: String = _observer_fsm.get_state_name()
	var ok: bool = _observer_fsm.transition_to(next_state)
	_add_log(
		"observer %s → %s : %s"
		% [from_name, _observer_fsm.get_state_name(next_state), "ok" if ok else "REJECTED"]
	)
	_refresh_status()


func _set_shopkeeper_cycle(cycle: int) -> void:
	var ok: bool = _shopkeeper_fsm.apply_shopkeeper_for_cycle(cycle)
	_add_log("shopkeeper cycle %d → %s (%s)" % [cycle, _shopkeeper_fsm.get_state_name(), ok])
	_refresh_status()


func _assert_marc_complicit() -> void:
	var ok: bool = _marc_fsm.current_state == NpcStateMachine.NPCState.COMPLICIT
	if not ok:
		ok = _marc_fsm.force_role_state(NpcStateMachine.NPCState.COMPLICIT)
	_add_log(
		"Marc COMPLICIT check: state=%s mechanical=%s ok=%s"
		% [_marc_fsm.get_state_name(), str(_marc_fsm.is_animation_mechanical()), str(ok)]
	)
	_refresh_status()


func _on_state_changed(
	from_state: NpcStateMachine.NPCState,
	to_state: NpcStateMachine.NPCState,
	npc_key: String
) -> void:
	_add_log(
		"%s changed %s → %s"
		% [npc_key, _observer_fsm.get_state_name(from_state), _observer_fsm.get_state_name(to_state)]
	)
	_refresh_status()


func _on_transition_rejected(
	from_state: NpcStateMachine.NPCState,
	to_state: NpcStateMachine.NPCState,
	npc_key: String
) -> void:
	_add_log(
		"%s REJECTED %s → %s"
		% [npc_key, _observer_fsm.get_state_name(from_state), _observer_fsm.get_state_name(to_state)]
	)
	_refresh_status()


func _add_log(message: String) -> void:
	_log_lines.append(message)
	if _log_lines.size() > MAX_LOG_LINES:
		_log_lines = _log_lines.slice(_log_lines.size() - MAX_LOG_LINES)
	_log_label.text = "\n".join(_log_lines)
	print("[npc_state_machine_test] %s" % message)


func _refresh_status() -> void:
	_status_label.text = (
		"Observer=%s (mech=%s) · Marc=%s (mech=%s) · Shopkeeper=%s (mech=%s / warmer=%s)"
		% [
			_observer_fsm.get_state_name(),
			str(_observer_fsm.is_animation_mechanical()),
			_marc_fsm.get_state_name(),
			str(_marc_fsm.is_animation_mechanical()),
			_shopkeeper_fsm.get_state_name(),
			str(_shopkeeper_fsm.is_animation_mechanical()),
			str(
				_shopkeeper_fsm.get_animation_profile()
				== NpcStateMachine.AnimationProfile.WARMER
			),
		]
	)
