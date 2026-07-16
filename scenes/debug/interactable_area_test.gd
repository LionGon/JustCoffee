extends Control
## Dev scene: InteractableArea verb gating (ISSUE-201 / #13 acceptance).

const MAX_LOG_LINES: int = 12

@onready var _log_label: Label = $UI/Panel/VBox/LogLabel
@onready var _verb_label: Label = $UI/Panel/VBox/VerbLabel
@onready var _hotspot: InteractableArea = $HotspotLayer/TestHotspot

var _event_log: PackedStringArray = PackedStringArray()


func _ready() -> void:
	EventBus.interactable_clicked.connect(_on_interactable_clicked)
	EventBus.verb_selected.connect(_on_verb_selected)
	$UI/Panel/VBox/VerbRow/ObserverButton.pressed.connect(
		_select_verb.bind(VerbSystem.Verb.OBSERVER)
	)
	$UI/Panel/VBox/VerbRow/GoButton.pressed.connect(_select_verb.bind(VerbSystem.Verb.ALLER))
	$UI/Panel/VBox/VerbRow/ForcerButton.pressed.connect(_select_verb.bind(VerbSystem.Verb.FORCER))
	$UI/Panel/VBox/CycleRow/Cycle0Button.pressed.connect(_set_cycle.bind(0))
	$UI/Panel/VBox/CycleRow/Cycle3Button.pressed.connect(_set_cycle.bind(3))
	_refresh_verb_label()


func _select_verb(verb: VerbSystem.Verb) -> void:
	VerbSystem.select_verb(verb, CycleStateManager.current_cycle)
	_refresh_verb_label()


func _set_cycle(cycle: int) -> void:
	CycleStateManager.current_cycle = cycle
	_log_action("Cycle set to %d" % cycle)
	_refresh_verb_label()


func _on_verb_selected(_verb: int) -> void:
	_refresh_verb_label()


func _on_interactable_clicked(interactable_id: String) -> void:
	var verb: VerbSystem.Verb = VerbSystem.selected_verb
	var outcome: String
	match verb:
		VerbSystem.Verb.ALLER:
			outcome = "GO → navigate toward '%s'" % interactable_id
		VerbSystem.Verb.OBSERVER:
			outcome = "OBSERVER → hedged description for '%s'" % interactable_id
		VerbSystem.Verb.FORCER:
			outcome = "FORCER → force interaction on '%s'" % interactable_id
		_:
			outcome = "verb %d on '%s'" % [verb as int, interactable_id]
	_log_action(outcome)


func _log_action(message: String) -> void:
	_event_log.append(message)
	if _event_log.size() > MAX_LOG_LINES:
		_event_log = _event_log.slice(_event_log.size() - MAX_LOG_LINES)
	_log_label.text = "Click log:\n%s" % "\n".join(_event_log)
	print("[interactable_area_test] %s" % message)


func _refresh_verb_label() -> void:
	var verb: VerbSystem.Verb = VerbSystem.selected_verb
	var greyed: bool = VerbSystem.is_verb_greyed(verb, CycleStateManager.current_cycle)
	_verb_label.text = (
		"Cycle %d · Selected: %s (%s) · greyed=%s · enabled on hotspot=%s"
		% [
			CycleStateManager.current_cycle,
			VerbSystem.get_label(verb, "en"),
			verb as int,
			str(greyed),
			str(verb as int in _hotspot.enabled_verbs),
		]
	)
