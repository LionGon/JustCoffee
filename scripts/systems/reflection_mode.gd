extends Node
## Controls the future Reflection Mode thermal-negative overlay.
## Cycle 1 gameplay keeps mirrors text-only unless the development flag is enabled.

const DEV_FORCE_ENABLE_FLAG: String = "dev_reflection_mode_force"

var _active: bool = false


func _ready() -> void:
	EventBus.cycle_advanced.connect(_on_cycle_advanced)
	call_deferred("sync_overlays")


func is_active() -> bool:
	return _active


func set_active(active: bool) -> void:
	if active and _is_cycle_one_locked():
		push_warning("ReflectionMode: activation is disabled during Cycle 1 without the dev flag")
		_active = false
	else:
		_active = active

	sync_overlays()
	EventBus.reflection_mode_toggled.emit(_active)


func toggle() -> void:
	set_active(not _active)


## Applies the current state to every registered screen-space overlay.
func sync_overlays() -> void:
	if not is_inside_tree():
		return

	var overlays: Array[Node] = get_tree().get_nodes_in_group("reflection_mode_overlay")
	for node: Node in overlays:
		if node is CanvasItem:
			var material: Material = (node as CanvasItem).material
			if material is ShaderMaterial:
				var shader_material: ShaderMaterial = material as ShaderMaterial
				shader_material.set_shader_parameter("reflection_active", _active)


func _on_cycle_advanced(new_cycle: int) -> void:
	if new_cycle == 1 and _is_cycle_one_locked() and _active:
		set_active(false)


func _is_cycle_one_locked() -> bool:
	return (
		CycleStateManager.current_cycle == 1
		and not (GameFlags.get_flag(DEV_FORCE_ENABLE_FLAG, false) as bool)
	)
