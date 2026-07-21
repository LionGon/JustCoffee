extends Node2D
## Café NPC placement stub for ISSUE-204 (full café art/beats = ISSUE-605 / ISSUE-901).
## Marc defaults to COMPLICIT. Grocery shopkeeper uses BENEVOLENT from Cycle 1+.


@onready var _marc_fsm: NpcStateMachine = $Marc/NpcStateMachine
@onready var _shopkeeper_fsm: NpcStateMachine = $GroceryShopkeeper/NpcStateMachine
@onready var _status: Label = $UI/Panel/VBox/StatusLabel


func _ready() -> void:
	CycleStateManager.set_district(CycleStateManager.DISTRICT_CAFE)
	# Marc: export initial_state is COMPLICIT; assert role after boot.
	if _marc_fsm.current_state != NpcStateMachine.NPCState.COMPLICIT:
		_marc_fsm.force_role_state(NpcStateMachine.NPCState.COMPLICIT)
	_shopkeeper_fsm.apply_shopkeeper_for_cycle(CycleStateManager.current_cycle)
	_marc_fsm.state_changed.connect(_on_any_state_changed)
	_shopkeeper_fsm.state_changed.connect(_on_any_state_changed)
	EventBus.cycle_advanced.connect(_on_cycle_advanced)
	_refresh_status()
	print(
		"[cafe_npc_setup] Marc=%s · Shopkeeper=%s · cycle=%d · cafe=%s"
		% [
			_marc_fsm.get_state_name(),
			_shopkeeper_fsm.get_state_name(),
			CycleStateManager.current_cycle,
			str(CycleStateManager.is_cafe_scene),
		]
	)


func _on_cycle_advanced(_new_cycle: int) -> void:
	_refresh_status()


func _on_any_state_changed(_from: NpcStateMachine.NPCState, _to: NpcStateMachine.NPCState) -> void:
	_refresh_status()


func _refresh_status() -> void:
	_status.text = (
		"Café NPC setup · Marc=%s (mechanical=%s) · Shopkeeper=%s (mechanical=%s) · cycle %d"
		% [
			_marc_fsm.get_state_name(),
			str(_marc_fsm.is_animation_mechanical()),
			_shopkeeper_fsm.get_state_name(),
			str(_shopkeeper_fsm.is_animation_mechanical()),
			CycleStateManager.current_cycle,
		]
	)
