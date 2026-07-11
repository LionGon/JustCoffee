extends Control
## Dev scene: verify GameFlags API and Vertical Slice seed keys (ISSUE-102 acceptance).

@onready var _status_label: Label = $VBox/StatusLabel
@onready var _detail_label: Label = $VBox/DetailLabel


func _ready() -> void:
	$VBox/SetElenaButton.pressed.connect(_on_set_elena_pressed)
	$VBox/ResetCycle1Button.pressed.connect(_on_reset_cycle_1_pressed)
	$VBox/SerializeButton.pressed.connect(_on_serialize_pressed)
	_refresh()


func _on_set_elena_pressed() -> void:
	GameFlags.set_flag(GameFlags.FLAG_ELENA_GAZE_COMPLETE, true)
	GameFlags.set_flag(GameFlags.FLAG_INNER_MONOLOGUE_SILENT, true)
	_refresh()


func _on_reset_cycle_1_pressed() -> void:
	GameFlags.reset_cycle_flags(1)
	_refresh()


func _on_serialize_pressed() -> void:
	var snapshot: Dictionary = GameFlags.serialize_state()
	GameFlags.deserialize_state(snapshot)
	_detail_label.text = "Round-trip serialize OK — keys: %s" % str(snapshot.keys())
	_refresh()


func _refresh() -> void:
	var lines: PackedStringArray = PackedStringArray([
		"elena_gaze_complete: %s" % GameFlags.get_flag(GameFlags.FLAG_ELENA_GAZE_COMPLETE, false),
		"cafe_spill_occurred: %s" % GameFlags.get_flag(GameFlags.FLAG_CAFE_SPILL_OCCURRED, false),
		"marc_apologized: %s" % GameFlags.get_flag(GameFlags.FLAG_MARC_APOLOGIZED, false),
		"inner_monologue_silent: %s" % GameFlags.get_flag(GameFlags.FLAG_INNER_MONOLOGUE_SILENT, false),
		"selected_outfit_id: '%s'" % GameFlags.get_flag(GameFlags.FLAG_SELECTED_OUTFIT_ID, ""),
	])
	_status_label.text = "\n".join(lines)
