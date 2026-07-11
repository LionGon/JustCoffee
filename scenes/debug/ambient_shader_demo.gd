extends Control
## Demo scene for ambient background shaders (ISSUE-305).

@onready var _cafe_texture: TextureRect = $CafeBackground
@onready var _steam_layer: ColorRect = $SteamLayer
@onready var _rain_overlay: ColorRect = $RainOverlay
@onready var _guide_panel: PanelContainer = $GuidePanel
@onready var _steam_zone_frame: ColorRect = $SteamZoneFrame
@onready var _cup_steam_frame: ColorRect = $CupSteamFrame
@onready var _status_label: Label = $GuidePanel/GuideVBox/StatusLabel
@onready var _toggle_rain: CheckBox = $ToggleBar/ToggleRain
@onready var _toggle_flicker: CheckBox = $ToggleBar/ToggleFlicker
@onready var _toggle_steam: CheckBox = $ToggleBar/ToggleSteam
@onready var _toggle_breathe: CheckBox = $ToggleBar/ToggleBreathe

var _cafe_tex: Texture2D
var _show_guides: bool = true

var _rain_on: bool = true
var _flicker_on: bool = true
var _steam_on: bool = true
var _breathe_on: bool = true

var _lamp_material: ShaderMaterial
var _rain_material: ShaderMaterial
var _steam_material: ShaderMaterial

const _SOLO_STEAM_STRENGTH: float = 0.028
const _NORMAL_STEAM_STRENGTH: float = 0.016


func _ready() -> void:
	_cafe_tex = _cafe_texture.texture
	_build_materials()
	_sync_checkboxes()
	_apply_all_effects()
	_update_guides()


func _build_materials() -> void:
	_lamp_material = ShaderMaterial.new()
	_lamp_material.shader = preload("res://assets/shaders/lamp_flicker.gdshader")

	_rain_material = ShaderMaterial.new()
	_rain_material.shader = preload("res://assets/shaders/rain_particle.gdshader")
	_rain_material.set_shader_parameter("rain_density", 0.8)
	_rain_material.set_shader_parameter("rain_speed", 2.8)

	_steam_material = ShaderMaterial.new()
	_steam_material.shader = preload("res://assets/shaders/steam_displacement.gdshader")
	_steam_material.set_shader_parameter("cafe_texture", _cafe_tex)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		var physical: Key = (event as InputEventKey).physical_keycode
		var logical: Key = (event as InputEventKey).keycode
		if physical == KEY_H or logical == KEY_H:
			_show_guides = not _show_guides
			_update_guides()
		elif physical == KEY_P or logical == KEY_P:
			_set_toggle("rain", not _rain_on)
		elif physical == KEY_F or logical == KEY_F:
			_set_toggle("flicker", not _flicker_on)
		elif physical == KEY_V or logical == KEY_V:
			_set_toggle("steam", not _steam_on)
		elif physical == KEY_B or logical == KEY_B:
			_set_toggle("breathe", not _breathe_on)
		elif physical == KEY_1 or logical == KEY_1:
			_solo("rain")
		elif physical == KEY_2 or logical == KEY_2:
			_solo("flicker")
		elif physical == KEY_3 or logical == KEY_3:
			_solo("steam")
		elif physical == KEY_4 or logical == KEY_4:
			_solo("breathe")
		elif physical == KEY_0 or logical == KEY_0:
			_set_all_toggles(true)


func _on_toggle_rain_toggled(enabled: bool) -> void:
	_set_toggle("rain", enabled)


func _on_toggle_flicker_toggled(enabled: bool) -> void:
	_set_toggle("flicker", enabled)


func _on_toggle_steam_toggled(enabled: bool) -> void:
	_set_toggle("steam", enabled)


func _on_toggle_breathe_toggled(enabled: bool) -> void:
	_set_toggle("breathe", enabled)


func _set_toggle(effect: String, enabled: bool) -> void:
	match effect:
		"rain":
			_rain_on = enabled
		"flicker":
			_flicker_on = enabled
		"steam":
			_steam_on = enabled
		"breathe":
			_breathe_on = enabled
	_sync_checkboxes()
	_apply_all_effects()


func _set_all_toggles(enabled: bool) -> void:
	_rain_on = enabled
	_flicker_on = enabled
	_steam_on = enabled
	_breathe_on = enabled
	_sync_checkboxes()
	_apply_all_effects()


func _solo(effect: String) -> void:
	_rain_on = effect == "rain"
	_flicker_on = effect == "flicker"
	_steam_on = effect == "steam"
	_breathe_on = effect == "breathe"
	_sync_checkboxes()
	_apply_all_effects()


func _sync_checkboxes() -> void:
	_toggle_rain.set_pressed_no_signal(_rain_on)
	_toggle_flicker.set_pressed_no_signal(_flicker_on)
	_toggle_steam.set_pressed_no_signal(_steam_on)
	_toggle_breathe.set_pressed_no_signal(_breathe_on)


func _apply_all_effects() -> void:
	_rain_overlay.visible = _rain_on
	if _rain_on:
		_rain_overlay.color = Color(1.0, 1.0, 1.0, 1.0)
		_rain_overlay.material = _rain_material

	if _flicker_on or _breathe_on:
		_lamp_material.set_shader_parameter("flicker_strength", 0.32 if _flicker_on else 0.0)
		_lamp_material.set_shader_parameter("flicker_speed", 4.0)
		_lamp_material.set_shader_parameter("breathe_strength", 0.018 if _breathe_on else 0.0)
		_cafe_texture.material = _lamp_material
	else:
		_cafe_texture.material = null

	var steam_solo: bool = _steam_on and not _rain_on and not _flicker_on and not _breathe_on
	_steam_layer.visible = _steam_on
	if _steam_on:
		_steam_layer.color = Color(1.0, 1.0, 1.0, 1.0)
		_steam_material.set_shader_parameter(
			"steam_strength",
			_SOLO_STEAM_STRENGTH if steam_solo else _NORMAL_STEAM_STRENGTH,
		)
		_steam_layer.material = _steam_material

	_steam_zone_frame.visible = _show_guides and _steam_on
	_cup_steam_frame.visible = _show_guides and _steam_on
	_update_status()


func _update_guides() -> void:
	_guide_panel.visible = _show_guides
	_steam_zone_frame.visible = _show_guides and _steam_on
	_cup_steam_frame.visible = _show_guides and _steam_on
	_update_status()


func _update_status() -> void:
	var on_off := func(enabled: bool) -> String:
		return "ON" if enabled else "off"
	_status_label.text = (
		"Pluie %s · Flicker %s · Vapeur %s · Respiration %s"
		% [on_off.call(_rain_on), on_off.call(_flicker_on), on_off.call(_steam_on), on_off.call(_breathe_on)]
	)
