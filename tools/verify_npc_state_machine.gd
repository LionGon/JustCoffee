extends Node
## Headless smoke checks for ISSUE-204 NpcStateMachine.
## Run: godot --headless --path . --scene res://tools/verify_npc_state_machine.tscn


var _failed: int = 0
var _passed: int = 0


func _ready() -> void:
	print("=== verify_npc_state_machine (ISSUE-204) ===")
	_assert_marc_complicit()
	_assert_scanning_to_benevolent_rejected()
	_assert_shopkeeper_cycle_benevolent()
	_assert_hostile_animation_mechanical()
	print(
		"=== RESULT: %d passed, %d failed ==="
		% [_passed, _failed]
	)
	get_tree().quit(1 if _failed > 0 else 0)


func _assert_marc_complicit() -> void:
	var fsm := NpcStateMachine.new()
	fsm.npc_id = "marc"
	fsm.initial_state = NpcStateMachine.NPCState.COMPLICIT
	add_child(fsm)
	_check(
		"Marc boots COMPLICIT",
		fsm.current_state == NpcStateMachine.NPCState.COMPLICIT
	)
	_check("Marc COMPLICIT is mechanical", fsm.is_animation_mechanical())
	fsm.queue_free()


func _assert_scanning_to_benevolent_rejected() -> void:
	var fsm := NpcStateMachine.new()
	fsm.npc_id = "observer"
	fsm.initial_state = NpcStateMachine.NPCState.IDLE
	add_child(fsm)
	_check("IDLE → SCANNING ok", fsm.transition_to(NpcStateMachine.NPCState.SCANNING))
	var rejected: bool = not fsm.transition_to(NpcStateMachine.NPCState.BENEVOLENT)
	_check("SCANNING → BENEVOLENT rejected", rejected)
	_check(
		"state stays SCANNING after reject",
		fsm.current_state == NpcStateMachine.NPCState.SCANNING
	)
	fsm.queue_free()


func _assert_shopkeeper_cycle_benevolent() -> void:
	var fsm := NpcStateMachine.new()
	fsm.npc_id = "grocery_shopkeeper"
	fsm.initial_state = NpcStateMachine.NPCState.IDLE
	add_child(fsm)
	_check("cycle 0 → IDLE", fsm.apply_shopkeeper_for_cycle(0))
	_check(
		"shopkeeper cycle 0 is IDLE",
		fsm.current_state == NpcStateMachine.NPCState.IDLE
	)
	_check("cycle 1 → BENEVOLENT", fsm.apply_shopkeeper_for_cycle(1))
	_check(
		"shopkeeper Cycle 1+ BENEVOLENT",
		fsm.current_state == NpcStateMachine.NPCState.BENEVOLENT
	)
	_check(
		"BENEVOLENT animation is warmer",
		fsm.get_animation_profile() == NpcStateMachine.AnimationProfile.WARMER
	)
	fsm.queue_free()


func _assert_hostile_animation_mechanical() -> void:
	var fsm := NpcStateMachine.new()
	fsm.npc_id = "hostile"
	fsm.initial_state = NpcStateMachine.NPCState.IDLE
	add_child(fsm)
	_check(
		"IDLE → HOSTILE_LATENT ok",
		fsm.transition_to(NpcStateMachine.NPCState.HOSTILE_LATENT)
	)
	_check(
		"HOSTILE_LATENT animation is mechanical (§9)",
		fsm.is_animation_mechanical()
	)
	fsm.queue_free()


func _check(label: String, condition: bool) -> void:
	if condition:
		_passed += 1
		print("PASS: %s" % label)
	else:
		_failed += 1
		printerr("FAIL: %s" % label)
