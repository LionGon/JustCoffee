extends Control
## Le Seuil — Cycle 0 apartment background scaffold (ISSUE-602).
## Control-based 1920×1080 layout: hotspot pixels match texture pixels 1:1.


@export var show_dev_hotspot_outlines: bool = true
@export var show_layer_overlays: bool = false
## Cache le composite : tu ne vois QUE les layers (fond magenta = transparent).
@export var hide_background_for_layer_test: bool = false
## 0 = toutes les layers ; 1=window 2=plant 3=mug 4=phone 5=vinyl
@export_range(0, 5, 1) var solo_layer_index: int = 0

const LAYER_ORDER: PackedStringArray = ["window", "plant", "mug", "phone", "vinyl"]

const LAYER_PATHS: Dictionary = {
	"window": "res://assets/backgrounds/layers/threshold_window_cycle0.png",
	"plant": "res://assets/backgrounds/layers/threshold_plant_cycle0.png",
	"mug": "res://assets/backgrounds/layers/threshold_mug_cycle0.png",
	"phone": "res://assets/backgrounds/layers/threshold_phone_cycle0.png",
	"vinyl": "res://assets/backgrounds/layers/threshold_vinyl_cycle0.png",
}

const HOTSPOT_RECTS: Dictionary = {
	"window": Rect2i(61, 0, 405, 744),
	"plant": Rect2i(334, 460, 259, 252),
	"mug": Rect2i(501, 817, 167, 172),
	"phone": Rect2i(787, 936, 232, 100),
	"vinyl": Rect2i(1463, 632, 286, 112),
}


@onready var _checkerboard: ColorRect = $Checkerboard
@onready var _background: TextureRect = $Background
@onready var _hotspots: Control = $Hotspots
@onready var _layers: Control = $Layers
@onready var _debug_label: Label = $DebugPanel/DebugLabel

var _layer_nodes: Dictionary = {}
var _outline_nodes: Dictionary = {}


func _ready() -> void:
	custom_minimum_size = Vector2(1920, 1080)
	size = Vector2(1920, 1080)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	set_process_input(true)
	_apply_layer_test_view()
	_build_layers()
	_build_hotspot_outlines()
	EventBus.district_changed.emit("threshold")
	print("[Threshold C0] district_changed → threshold")
	print("[Threshold C0] Layers: F1=window F2=plant F3=mug F4=phone F5=vinyl F6=toutes")
	print("[Threshold C0] Clics: utilise _input (bypass GUI) — regarde Output")
	_update_debug_hint()


func _apply_layer_test_view() -> void:
	_checkerboard.visible = hide_background_for_layer_test
	_background.visible = not hide_background_for_layer_test


func _update_debug_hint() -> void:
	var solo_name: String = "toutes" if solo_layer_index == 0 else LAYER_ORDER[solo_layer_index - 1]
	_debug_label.text = (
		"Clics: dans les zones amber (Output). "
		+ "Layer solo: %s | F1-F5 une layer, F6 toutes | Fond magenta: %s"
		% [
			solo_name,
			"OUI" if hide_background_for_layer_test else "non",
		]
	)


func _input(event: InputEvent) -> void:
	if not event is InputEventMouseButton:
		return
	var mouse_event: InputEventMouseButton = event as InputEventMouseButton
	if not mouse_event.pressed or mouse_event.button_index != MOUSE_BUTTON_LEFT:
		return
	var local_pos: Vector2 = get_local_mouse_position()
	print("[Threshold C0] clic @ ", local_pos, " (scene ", size, ")")
	_try_hotspot_click(local_pos)
	get_viewport().set_input_as_handled()


func _unhandled_input(event: InputEvent) -> void:
	if not event is InputEventKey or not event.pressed or event.echo:
		return
	var key_event: InputEventKey = event as InputEventKey
	var next_index: int = -1
	match key_event.keycode:
		KEY_F1:
			next_index = 1
		KEY_F2:
			next_index = 2
		KEY_F3:
			next_index = 3
		KEY_F4:
			next_index = 4
		KEY_F5:
			next_index = 5
		KEY_F6:
			next_index = 0
	if next_index < 0:
		return
	solo_layer_index = next_index
	_apply_solo_layer_visibility()
	_update_debug_hint()
	get_viewport().set_input_as_handled()


func _build_hotspot_outlines() -> void:
	for child: Node in _hotspots.get_children():
		child.queue_free()
	_outline_nodes.clear()
	for interactable_id: String in HOTSPOT_RECTS:
		var rect: Rect2i = HOTSPOT_RECTS[interactable_id]
		var outline := ColorRect.new()
		outline.name = "%sOutline" % interactable_id.capitalize()
		outline.position = Vector2(rect.position)
		outline.size = Vector2(rect.size)
		outline.color = Color(1.0, 0.85, 0.4, 0.35) if show_dev_hotspot_outlines else Color(0, 0, 0, 0)
		outline.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_hotspots.add_child(outline)
		_outline_nodes[interactable_id] = outline


func _try_hotspot_click(local_pos: Vector2) -> void:
	for interactable_id: String in HOTSPOT_RECTS:
		var rect: Rect2i = HOTSPOT_RECTS[interactable_id]
		var hitbox := Rect2(Vector2(rect.position), Vector2(rect.size))
		if hitbox.has_point(local_pos):
			_emit_hotspot_click(interactable_id)
			return
	print("[Threshold C0] hors hotspot")


func _emit_hotspot_click(interactable_id: String) -> void:
	var msg: String = "interactable_clicked → %s" % interactable_id
	_debug_label.text = msg
	print("[Threshold C0] ", msg)
	EventBus.interactable_clicked.emit(interactable_id)


func _build_layers() -> void:
	for child: Node in _layers.get_children():
		child.queue_free()
	_layer_nodes.clear()
	for layer_id: String in LAYER_ORDER:
		var texture: Texture2D = load(LAYER_PATHS[layer_id]) as Texture2D
		var layer := TextureRect.new()
		layer.name = "%sLayer" % layer_id.capitalize()
		layer.set_anchors_preset(Control.PRESET_TOP_LEFT)
		layer.position = Vector2.ZERO
		layer.size = Vector2(1920, 1080)
		layer.texture = texture
		layer.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		layer.stretch_mode = TextureRect.STRETCH_KEEP
		layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_layers.add_child(layer)
		_layer_nodes[layer_id] = layer
		if texture == null:
			print("[Threshold C0] ERREUR texture manquante: ", LAYER_PATHS[layer_id])
		else:
			print("[Threshold C0] texture OK ", layer_id, " → ", texture.get_size())
	_apply_solo_layer_visibility()


func _apply_solo_layer_visibility() -> void:
	var show_any: bool = show_layer_overlays or hide_background_for_layer_test
	for i: int in LAYER_ORDER.size():
		var layer_id: String = LAYER_ORDER[i]
		var layer: TextureRect = _layer_nodes[layer_id] as TextureRect
		var show_layer: bool = show_any and (solo_layer_index == 0 or (i + 1) == solo_layer_index)
		layer.visible = show_layer
		layer.modulate = Color(1.35, 1.35, 1.35, 1.0) if show_layer and solo_layer_index > 0 else Color.WHITE
		if show_layer:
			print("[Threshold C0] affiche layer → ", layer_id)
