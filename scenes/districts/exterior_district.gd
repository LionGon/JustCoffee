extends Control
## Shared exterior district scaffold (ISSUE-604 / ISSUE-206).
## Flat 1920×1080 background + rain/flicker shaders + saturation overlay.


@export var district_id: String = "artery"
@export var cycle: int = 0
@export var placeholder_color: Color = Color(0.2, 0.19, 0.18, 1.0)
@export var enable_rain: bool = true
@export var enable_flicker: bool = true
@export var rain_density: float = 0.8
@export var rain_speed: float = 2.8
@export var flicker_strength: float = 0.28
@export var flicker_speed: float = 4.0
@export var show_dev_panel: bool = true

@onready var _placeholder: ColorRect = $Placeholder
@onready var _background: TextureRect = $Background
@onready var _rain_overlay: ColorRect = $RainOverlay
@onready var _debug_label: Label = $DebugPanel/DebugLabel

var _lamp_material: ShaderMaterial
var _rain_material: ShaderMaterial
var _rain_on: bool = true
var _flicker_on: bool = true


func _ready() -> void:
	_configure_district()
	custom_minimum_size = Vector2(1920, 1080)
	size = Vector2(1920, 1080)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_rain_on = enable_rain
	_flicker_on = enable_flicker
	_build_materials()
	_load_background()
	_apply_shader_effects()
	_debug_panel_visible()
	_update_debug_label()
	EventBus.district_changed.emit(district_id)
	print("[%s C%d] district_changed → %s" % [_district_label(), cycle, district_id])


func _configure_district() -> void:
	pass


func _unhandled_input(event: InputEvent) -> void:
	if not show_dev_panel or not event is InputEventKey or not event.pressed or event.echo:
		return
	var key_event: InputEventKey = event as InputEventKey
	match key_event.keycode:
		KEY_P:
			_rain_on = not _rain_on
			_apply_shader_effects()
			_update_debug_label()
			get_viewport().set_input_as_handled()
		KEY_F:
			_flicker_on = not _flicker_on
			_apply_shader_effects()
			_update_debug_label()
			get_viewport().set_input_as_handled()


func _district_label() -> String:
	return district_id.capitalize()


func _background_path() -> String:
	return "res://assets/backgrounds/%s_main_cycle%d.png" % [district_id, cycle]


func _build_materials() -> void:
	_lamp_material = ShaderMaterial.new()
	_lamp_material.shader = preload("res://assets/shaders/lamp_flicker.gdshader")

	_rain_material = ShaderMaterial.new()
	_rain_material.shader = preload("res://assets/shaders/rain_particle.gdshader")
	_rain_material.set_shader_parameter("rain_density", rain_density)
	_rain_material.set_shader_parameter("rain_speed", rain_speed)


func _load_background() -> void:
	var path: String = _background_path()
	if ResourceLoader.exists(path):
		var texture: Texture2D = load(path) as Texture2D
		_background.texture = texture
		_placeholder.visible = false
		_background.visible = true
		print("[%s C%d] background OK → %s" % [_district_label(), cycle, path])
	else:
		_placeholder.color = placeholder_color
		_placeholder.visible = true
		_background.visible = false
		push_warning("[%s C%d] art pending: %s" % [_district_label(), cycle, path])


func _apply_shader_effects() -> void:
	_rain_overlay.visible = _rain_on
	if _rain_on:
		_rain_overlay.color = Color(1.0, 1.0, 1.0, 1.0)
		_rain_overlay.material = _rain_material
	else:
		_rain_overlay.material = null

	if _flicker_on and _background.visible:
		_lamp_material.set_shader_parameter("flicker_strength", flicker_strength)
		_lamp_material.set_shader_parameter("flicker_speed", flicker_speed)
		_lamp_material.set_shader_parameter("breathe_strength", 0.0)
		_background.material = _lamp_material
	else:
		_background.material = null


func _debug_panel_visible() -> void:
	$DebugPanel.visible = show_dev_panel


func _update_debug_label() -> void:
	var rain_state: String = "ON" if _rain_on else "off"
	var flicker_state: String = "ON" if _flicker_on else "off"
	var art_state: String = "loaded" if _background.visible else "pending → %s" % _background_path().get_file()
	_debug_label.text = (
		"%s · cycle %d · art %s · rain %s · flicker %s (P/F toggle)"
		% [_district_label(), cycle, art_state, rain_state, flicker_state]
	)
