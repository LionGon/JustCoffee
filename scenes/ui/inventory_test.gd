extends Control
## Dev scene: strategy inventory hooks (ISSUE-105 acceptance).

@onready var _status_label: Label = $VBox/StatusLabel
@onready var _hint_label: Label = $VBox/HintLabel

var _last_action: String = ""


func _ready() -> void:
	_refresh()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		var key_event: InputEventKey = event as InputEventKey
		var physical: Key = key_event.physical_keycode
		var logical: Key = key_event.keycode
		if physical == KEY_P or logical == KEY_P:
			_use(InventoryManager.ITEM_PHONE_SCREEN_ON, "Phone (blocks OBSERVER gaze)")
		elif physical == KEY_H or logical == KEY_H:
			_use(InventoryManager.ITEM_HEADPHONES, "Headphones")
		elif physical == KEY_E or logical == KEY_E:
			_use(InventoryManager.ITEM_EYES_DOWN, "Eyes down (−saturation)")
		elif physical == KEY_F or logical == KEY_F:
			_use(InventoryManager.ITEM_FAKE_PHONE_CALL, "Fake phone call (single use)")


func _use(item_id: String, label: String) -> void:
	var ok: bool = InventoryManager.use_item(item_id)
	_last_action = "%s: %s" % [label, "used" if ok else "failed"]
	_refresh()


func _refresh() -> void:
	var lines: PackedStringArray = PackedStringArray()
	for item: Resource in InventoryManager.get_all_items():
		var name_key: String = item.get("name_key") as String
		var localized: String = LocalizationManager.get_text(name_key)
		lines.append("%s — %s" % [item.get("id"), localized])
	lines.append("")
	lines.append("observer_gaze_blocked: %s" % InventoryManager.is_observer_gaze_blocked())
	if not _last_action.is_empty():
		lines.append(_last_action)
	_status_label.text = "\n".join(lines)
