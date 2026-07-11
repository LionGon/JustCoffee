extends Node
## Tracks saturation 0.0–1.0 and drives shader/audio listeners via EventBus.
## The gauge is NEVER exposed to player UI (RULES.md §6.1).

const DISSOCIATION_THRESHOLD: float = 0.85

## Post-Elena third saturation state (RULES.md §5) — alters dissociation curve.
var post_elena_state: bool = false

var saturation_level: float = 0.0

var _in_dissociation: bool = false


func add_saturation(delta: float, _source: String) -> void:
	saturation_level = clampf(saturation_level + delta, 0.0, 1.0)
	apply_saturation()


func reduce_saturation(delta: float, _source: String) -> void:
	saturation_level = clampf(saturation_level - delta, 0.0, 1.0)
	apply_saturation()


## Sawtooth partial reset at each cycle opening (RULES.md §6.1).
## Cycle 0 clears fully; later cycles only partially release tension.
func apply_cycle_opening_reset(cycle: int) -> void:
	match cycle:
		0:
			saturation_level = 0.0
		1:
			saturation_level = clampf(saturation_level * 0.4, 0.0, 0.12)
		2:
			saturation_level = clampf(saturation_level * 0.45, 0.0, 0.18)
		3:
			saturation_level = clampf(saturation_level * 0.5, 0.0, 0.22)
		4:
			saturation_level = clampf(saturation_level * 0.55, 0.0, 0.28)
		_:
			saturation_level = clampf(saturation_level * 0.5, 0.0, 0.25)
	apply_saturation()


func apply_saturation() -> void:
	EventBus.saturation_changed.emit(saturation_level)
	_push_overlay_shader_params()
	_update_dissociation()


func dissociation_state() -> void:
	EventBus.dissociation_state_changed.emit(_in_dissociation)


func set_post_elena_state(active: bool) -> void:
	post_elena_state = active
	apply_saturation()


func _update_dissociation() -> void:
	var threshold: float = DISSOCIATION_THRESHOLD
	if post_elena_state:
		threshold *= 0.9
	var should_dissociate: bool = saturation_level >= threshold
	if should_dissociate == _in_dissociation:
		return
	_in_dissociation = should_dissociate
	dissociation_state()


func _push_overlay_shader_params() -> void:
	if not is_inside_tree():
		return
	var overlays: Array[Node] = get_tree().get_nodes_in_group("saturation_overlay")
	for node: Node in overlays:
		if node is CanvasItem:
			var material: Material = (node as CanvasItem).material
			if material is ShaderMaterial:
				var shader_material: ShaderMaterial = material as ShaderMaterial
				shader_material.set_shader_parameter("saturation_level", saturation_level)
				shader_material.set_shader_parameter("post_elena_state", post_elena_state)
