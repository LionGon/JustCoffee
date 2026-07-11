extends Node
## Syncs GameFlags and CycleStateManager into Dialogic variables (ISSUE-701).
##
## Call `sync_all()` after game state changes and on `LocalizationManager.locale_changed`.


func _ready() -> void:
	call_deferred("_initialize_bridge")


func _initialize_bridge() -> void:
	var dialogic: Node = _get_dialogic()
	if dialogic == null:
		push_warning("DialogicBridge: Dialogic autoload missing — enable the plugin in Project Settings.")
		return

	LocalizationManager.locale_changed.connect(_on_locale_changed)
	EventBus.cycle_advanced.connect(_on_cycle_advanced)
	EventBus.district_changed.connect(_on_district_changed)

	sync_all()
	_apply_dialogic_locale()


func sync_all() -> void:
	if _get_dialogic() == null:
		return

	_set_dialogic_variable("current_cycle", CycleStateManager.current_cycle)
	_set_dialogic_variable("current_district", CycleStateManager.current_district)
	_set_dialogic_variable("district_index", CycleStateManager.district_index)
	_set_dialogic_variable("is_cafe_scene", CycleStateManager.is_cafe_scene)

	_set_dialogic_variable("elena_gaze_complete", GameFlags.get_flag(GameFlags.FLAG_ELENA_GAZE_COMPLETE, false))
	_set_dialogic_variable("cafe_spill_occurred", GameFlags.get_flag(GameFlags.FLAG_CAFE_SPILL_OCCURRED, false))
	_set_dialogic_variable("marc_apologized", GameFlags.get_flag(GameFlags.FLAG_MARC_APOLOGIZED, false))
	_set_dialogic_variable("inner_monologue_silent", GameFlags.get_flag(GameFlags.FLAG_INNER_MONOLOGUE_SILENT, false))
	_set_dialogic_variable("selected_outfit_id", GameFlags.get_flag(GameFlags.FLAG_SELECTED_OUTFIT_ID, ""))


func get_timeline_path(relative_path: String) -> String:
	var locale: String = LocalizationManager.get_locale()
	return "res://data/dialogues/%s/%s" % [locale, relative_path]


func _apply_dialogic_locale() -> void:
	TranslationServer.set_locale(LocalizationManager.get_dialogic_locale())


func _on_locale_changed(_new_locale: String) -> void:
	_apply_dialogic_locale()


func _on_cycle_advanced(_new_cycle: int) -> void:
	sync_all()


func _on_district_changed(_district_id: String) -> void:
	sync_all()


func _get_dialogic() -> Node:
	var tree: SceneTree = get_tree()
	if tree == null:
		return null
	return tree.root.get_node_or_null("Dialogic")


func _set_dialogic_variable(name: String, value: Variant) -> void:
	var dialogic: Node = _get_dialogic()
	if dialogic == null or not dialogic.has_method("get_subsystem"):
		return
	var variables: Node = dialogic.call("get_subsystem", "VAR") as Node
	if variables != null and variables.has_method("set_variable"):
		variables.call("set_variable", name, value)
