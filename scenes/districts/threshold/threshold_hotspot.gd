extends Area2D
## Placeholder hotspot for Le Seuil interactables (ISSUE-201 will wire gameplay).
## Export `interactable_id` matches VISUAL_STYLE.md §5 / §10 naming.


@export var interactable_id: String = ""


func _ready() -> void:
	input_pickable = true
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)


func _on_mouse_entered() -> void:
	if has_node("DevOutline"):
		$DevOutline.modulate = Color(1.0, 0.85, 0.4, 0.55)


func _on_mouse_exited() -> void:
	if has_node("DevOutline"):
		$DevOutline.modulate = Color(1.0, 0.85, 0.4, 0.25)
