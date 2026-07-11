extends Control
## Dev scene: verb availability and cycle gating (ISSUE-107 acceptance).

@onready var _cycle_label: Label = $VBox/CycleLabel
@onready var _verb_list: Label = $VBox/VerbListLabel
@onready var _selected_label: Label = $VBox/SelectedLabel
@onready var _hint_label: Label = $VBox/HintLabel
@onready var _action_label: Label = $VBox/ActionLabel

var _cycle: int = 0
var _highlight_index: int = 0
var _force_reculer: bool = false
var _npc_grey_aborder: bool = false
var _last_action: String = ""


func _ready() -> void:
	EventBus.verb_selected.connect(_on_verb_selected)
	_refresh()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		var key_event: InputEventKey = event as InputEventKey
		var physical: Key = key_event.physical_keycode
		var logical: Key = key_event.keycode
		# F1–F4 = narrative cycle (NOT verb selection).
		if physical == KEY_F1 or logical == KEY_F1:
			_set_cycle(0)
		elif physical == KEY_F2 or logical == KEY_F2:
			_set_cycle(1)
		elif physical == KEY_F3 or logical == KEY_F3:
			_set_cycle(2)
		elif physical == KEY_F4 or logical == KEY_F4:
			_set_cycle(3)
		elif physical in [KEY_UP, KEY_DOWN] or logical in [KEY_UP, KEY_DOWN]:
			_move_highlight(1 if physical == KEY_DOWN or logical == KEY_DOWN else -1)
		elif physical in [KEY_ENTER, KEY_KP_ENTER, KEY_SPACE] or logical in [KEY_ENTER, KEY_KP_ENTER, KEY_SPACE]:
			_confirm_highlighted_verb()
		elif physical == KEY_R or logical == KEY_R:
			_force_reculer = not _force_reculer
			_last_action = "Force RECULER: %s" % _force_reculer
			_refresh()
		elif physical == KEY_G or logical == KEY_G:
			_npc_grey_aborder = not _npc_grey_aborder
			_last_action = "Grey ABORDER (NPC stub): %s" % _npc_grey_aborder
			_refresh()


func _set_cycle(cycle: int) -> void:
	_cycle = cycle
	_highlight_index = 0
	_last_action = "Cycle set to %d (F%d)" % [cycle, cycle + 1]
	_refresh()


func _move_highlight(delta: int) -> void:
	var count: int = VerbSystem.get_available_verbs(_cycle).size()
	if count == 0:
		return
	_highlight_index = posmod(_highlight_index + delta, count)
	_last_action = "Highlight verb #%d" % (_highlight_index + 1)
	_refresh()


func _confirm_highlighted_verb() -> void:
	var verbs: Array[VerbSystem.Verb] = VerbSystem.get_available_verbs(_cycle)
	if _highlight_index < 0 or _highlight_index >= verbs.size():
		return
	var verb: VerbSystem.Verb = verbs[_highlight_index]
	var context: Dictionary = _build_context()
	if VerbSystem.is_verb_greyed(verb, _cycle, context):
		_last_action = "%s is greyed — selection blocked" % VerbSystem.Verb.keys()[verb]
		_refresh()
		return
	VerbSystem.select_verb(verb, _cycle, context)
	_last_action = "Selected %s" % VerbSystem.Verb.keys()[verb]


func _on_verb_selected(verb: int) -> void:
	_selected_label.text = "Selected: %s / %s" % [
		VerbSystem.get_label(verb as VerbSystem.Verb, "fr"),
		VerbSystem.get_label(verb as VerbSystem.Verb, "en"),
	]


func _build_context() -> Dictionary:
	return {
		"force_reculer": _force_reculer,
		"npc_grey_aborder": _npc_grey_aborder,
	}


func _refresh() -> void:
	_cycle_label.text = "Narrative cycle: %d" % _cycle
	_hint_label.text = (
		"F1–F4 = change cycle (not a verb)\n"
		+ "↑ ↓ = move highlight · Enter/Space = select highlighted verb\n"
		+ "R = force RECULER only · G = toggle grey ABORDER (Cycle 3+)"
	)
	var lines: PackedStringArray = PackedStringArray()
	var context: Dictionary = _build_context()
	var index: int = 0
	for verb: VerbSystem.Verb in VerbSystem.get_available_verbs(_cycle):
		var greyed: bool = VerbSystem.is_verb_greyed(verb, _cycle, context)
		var state: String = "greyed" if greyed else "active"
		var marker: String = ">" if index == _highlight_index else " "
		lines.append(
			"%s [%d] %s — %s / %s [%s]"
			% [
				marker,
				index + 1,
				VerbSystem.Verb.keys()[verb],
				VerbSystem.get_label(verb, "fr"),
				VerbSystem.get_label(verb, "en"),
				state,
			]
		)
		index += 1
	_verb_list.text = "\n".join(lines)
	_action_label.text = _last_action
	_on_verb_selected(VerbSystem.selected_verb as int)
