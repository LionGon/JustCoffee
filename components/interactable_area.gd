class_name InteractableArea
extends Area2D
## Clickable hotspot base for point-and-click (ISSUE-201 / #13).
## Emits EventBus.interactable_clicked when the active verb is allowed and not greyed.


@export var interactable_id: String = ""
@export var cursor_hint: String = ""
@export var enabled_verbs: Array[int] = []


func _ready() -> void:
	input_pickable = true
	input_event.connect(_on_input_event)
	# ColorRect outlines must not steal Area2D mouse picking.
	if has_node("DevOutline") and $DevOutline is Control:
		($DevOutline as Control).mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_input_event(
	_viewport: Node,
	event: InputEvent,
	_shape_idx: int
) -> void:
	if not event is InputEventMouseButton:
		return
	var mouse_event: InputEventMouseButton = event as InputEventMouseButton
	if mouse_event.button_index != MOUSE_BUTTON_LEFT or not mouse_event.pressed:
		return
	if not _can_interact():
		return
	EventBus.interactable_clicked.emit(interactable_id)
	_viewport.set_input_as_handled()


func _can_interact() -> bool:
	if interactable_id.is_empty():
		return false
	var verb: VerbSystem.Verb = VerbSystem.selected_verb
	if verb as int not in enabled_verbs:
		return false
	if VerbSystem.is_verb_greyed(verb, CycleStateManager.current_cycle):
		return false
	return true
