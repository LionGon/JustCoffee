extends Control
## Focused ISSUE-306 / #24 test — Reflection Mode only.


@onready var _status: Label = $Panel/VBox/StatusLabel
@onready var _hint: Label = $Panel/VBox/HintLabel
@onready var _log: Label = $Panel/VBox/LogLabel

var _lines: PackedStringArray = PackedStringArray()


func _ready() -> void:
	EventBus.reflection_mode_toggled.connect(_on_toggled)
	EventBus.cycle_advanced.connect(_on_cycle)
	$Panel/VBox/Step1Row/Cycle0Button.pressed.connect(_on_cycle_0)
	$Panel/VBox/Step1Row/ToggleButton.pressed.connect(_on_toggle)
	$Panel/VBox/Step2Row/Cycle1Button.pressed.connect(_on_cycle_1)
	$Panel/VBox/Step2Row/TryBlockedButton.pressed.connect(_on_try_blocked)
	$Panel/VBox/Step3Row/ForceOnButton.pressed.connect(_on_force_on)
	$Panel/VBox/Step3Row/ClearForceButton.pressed.connect(_on_clear_force)
	_boot_clean_cycle(0)
	_add_log("Ready — follow steps 1 → 2 → 3 (yellow buttons).")
	_refresh()


func _on_cycle_0() -> void:
	_boot_clean_cycle(0)
	_add_log("STEP 1a: Cycle 0 (force flag cleared)")


func _on_toggle() -> void:
	ReflectionMode.toggle()
	_add_log("STEP 1b: Toggle reflection → %s" % ("ON" if ReflectionMode.is_active() else "OFF"))


func _on_cycle_1() -> void:
	_boot_clean_cycle(1)
	_add_log("STEP 2a: Cycle 1 (force flag cleared) — reflection must stay OFF")


func _on_try_blocked() -> void:
	ReflectionMode.toggle()
	if ReflectionMode.is_active():
		_add_log("STEP 2b FAIL: reflection turned ON in Cycle 1 (should be blocked)")
	else:
		_add_log("STEP 2b OK: blocked in Cycle 1 (still OFF)")


func _on_force_on() -> void:
	GameFlags.set_flag(ReflectionMode.DEV_FORCE_ENABLE_FLAG, true)
	ReflectionMode.set_active(true)
	_add_log("STEP 3: Force ON → %s" % ("ON" if ReflectionMode.is_active() else "OFF"))


func _on_clear_force() -> void:
	GameFlags.set_flag(ReflectionMode.DEV_FORCE_ENABLE_FLAG, false)
	if CycleStateManager.current_cycle == 1 and ReflectionMode.is_active():
		ReflectionMode.set_active(false)
	_add_log("Cleared force flag")


func _boot_clean_cycle(cycle: int) -> void:
	GameFlags.set_flag(ReflectionMode.DEV_FORCE_ENABLE_FLAG, false)
	CycleStateManager.boot_dev_cycle(cycle)
	# Ensure reflection off when entering a clean cycle (Cycle 1 lock + retest).
	if ReflectionMode.is_active():
		ReflectionMode.set_active(false)
	_refresh()


func _on_toggled(active: bool) -> void:
	_add_log("EventBus.reflection_mode_toggled(%s)" % str(active))
	_refresh()


func _on_cycle(new_cycle: int) -> void:
	_add_log("EventBus.cycle_advanced(%d)" % new_cycle)
	_refresh()


func _add_log(message: String) -> void:
	_lines.append(message)
	if _lines.size() > 10:
		_lines = _lines.slice(_lines.size() - 10)
	_log.text = "\n".join(_lines)
	print("[reflection_mode_test] %s" % message)


func _refresh() -> void:
	var cycle: int = CycleStateManager.current_cycle
	var active: bool = ReflectionMode.is_active()
	var force: bool = GameFlags.get_flag(ReflectionMode.DEV_FORCE_ENABLE_FLAG, false) as bool
	_status.text = "Cycle %d · Reflection %s · Force flag %s" % [
		cycle,
		"ON (thermal negative)" if active else "OFF (normal)",
		"YES" if force else "no",
	]
	if cycle == 1 and not force:
		_hint.text = "Cycle 1: Reflection is LOCKED (café mirror = text only). Use STEP 3 to force."
	elif cycle == 1 and force:
		_hint.text = "Cycle 1 + force: Reflection allowed (dev only)."
	else:
		_hint.text = "Cycle 0: Reflection toggle should work freely."
