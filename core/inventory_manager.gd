extends Node
## Strategy inventory — items are coping strategies, not protective stats (RULES.md §6.3).

const ITEM_PHONE_SCREEN_ON: String = "phone_screen_on"
const ITEM_HEADPHONES: String = "headphones"
const ITEM_ALTERNATIVE_ROUTE: String = "alternative_route"
const ITEM_FAKE_PHONE_CALL: String = "fake_phone_call"
const ITEM_EYES_DOWN: String = "eyes_down"
const ITEM_KEYS_BETWEEN_FINGERS: String = "keys_between_fingers"

const FLAG_OBSERVER_GAZE_BLOCKED: String = "observer_gaze_blocked"
const FLAG_HEADPHONES_ACTIVE: String = "headphones_active"
const FLAG_ALTERNATIVE_ROUTE_TAKEN: String = "alternative_route_taken"
const FLAG_EYES_DOWN_ACTIVE: String = "eyes_down_active"

const _StrategyItemScript = preload("res://data/game_state/strategy_item.gd")

var _items: Dictionary = {}


func _ready() -> void:
	_seed_vertical_slice_items()


func add_item(item: Resource) -> void:
	if item == null:
		push_warning("InventoryManager: cannot add null item")
		return
	var item_id: String = item.get("id") as String
	if item_id.is_empty():
		push_warning("InventoryManager: cannot add item without id")
		return
	_items[item_id] = item


func remove_item(item_id: String) -> void:
	_items.erase(item_id)


func has_item(item_id: String) -> bool:
	return _items.has(item_id)


func use_item(item_id: String) -> bool:
	if not has_item(item_id):
		return false
	var item: Resource = _items[item_id]
	match item_id:
		ITEM_PHONE_SCREEN_ON:
			GameFlags.set_flag(FLAG_OBSERVER_GAZE_BLOCKED, true)
		ITEM_HEADPHONES:
			GameFlags.set_flag(FLAG_HEADPHONES_ACTIVE, true)
		ITEM_ALTERNATIVE_ROUTE:
			GameFlags.set_flag(FLAG_ALTERNATIVE_ROUTE_TAKEN, true)
		ITEM_FAKE_PHONE_CALL:
			if item.get("single_use"):
				remove_item(item_id)
			return true
		ITEM_EYES_DOWN:
			GameFlags.set_flag(FLAG_EYES_DOWN_ACTIVE, true)
			SaturationManager.reduce_saturation(0.02, "eyes_down")
		ITEM_KEYS_BETWEEN_FINGERS:
			pass
		_:
			push_warning("InventoryManager: no use handler for '%s'" % item_id)
			return false
	if item.get("single_use") and item_id != ITEM_FAKE_PHONE_CALL:
		remove_item(item_id)
	return true


func get_all_items() -> Array:
	var result: Array = []
	for item_id: String in _items.keys():
		result.append(_items[item_id])
	return result


func is_observer_gaze_blocked() -> bool:
	return GameFlags.get_flag(FLAG_OBSERVER_GAZE_BLOCKED, false) as bool


func _seed_vertical_slice_items() -> void:
	add_item(_make_item(
		ITEM_PHONE_SCREEN_ON,
		"item.phone_screen_on.name",
		"item.phone_screen_on.description",
		"gaze_block",
		"item.phone_screen_on.cost",
		false,
	))
	add_item(_make_item(
		ITEM_HEADPHONES,
		"item.headphones.name",
		"item.headphones.description",
		"audio_muffle",
		"item.headphones.cost",
		false,
	))
	add_item(_make_item(
		ITEM_ALTERNATIVE_ROUTE,
		"item.alternative_route.name",
		"item.alternative_route.description",
		"narrative_cost",
		"item.alternative_route.cost",
		false,
	))
	add_item(_make_item(
		ITEM_FAKE_PHONE_CALL,
		"item.fake_phone_call.name",
		"item.fake_phone_call.description",
		"defuse",
		"item.fake_phone_call.cost",
		true,
	))
	add_item(_make_item(
		ITEM_EYES_DOWN,
		"item.eyes_down.name",
		"item.eyes_down.description",
		"saturation_drain",
		"item.eyes_down.cost",
		false,
	))
	add_item(_make_item(
		ITEM_KEYS_BETWEEN_FINGERS,
		"item.keys_between_fingers.name",
		"item.keys_between_fingers.description",
		"narrative_only",
		"item.keys_between_fingers.cost",
		false,
	))


func _make_item(
	item_id: String,
	name_key: String,
	description_key: String,
	mechanic_type: String,
	cost_description_key: String,
	single_use: bool,
) -> Resource:
	var item: Resource = _StrategyItemScript.new()
	item.id = item_id
	item.name_key = name_key
	item.description_key = description_key
	item.mechanic_type = mechanic_type
	item.cost_description_key = cost_description_key
	item.single_use = single_use
	return item
