extends Control
## Dev scene validating Resource-backed verb interaction dispatch (ISSUE-202 / #14).


const MAX_LOG_LINES: int = 12
const FLAG_KEY: String = "debug_verb_receiver_used"

@onready var _log_label: Label = $UI/Panel/VBox/LogLabel
@onready var _verb_label: Label = $UI/Panel/VBox/VerbLabel
@onready var _observer_button: Button = $UI/Panel/VBox/VerbRow/ObserverButton
@onready var _approach_button: Button = $UI/Panel/VBox/VerbRow/ApproachButton
@onready var _use_button: Button = $UI/Panel/VBox/VerbRow/UseButton

var _event_log: PackedStringArray = PackedStringArray()
var _verb_receiver: VerbReceiver


func _ready() -> void:
	EventBus.interactable_clicked.connect(_on_interactable_clicked)
	EventBus.inner_monologue_triggered.connect(_on_inner_monologue_triggered)
	EventBus.dialogue_started.connect(_on_dialogue_started)
	EventBus.scene_change_requested.connect(_on_scene_change_requested)
	_observer_button.pressed.connect(_select_verb.bind(VerbSystem.Verb.OBSERVER))
	_approach_button.pressed.connect(_select_verb.bind(VerbSystem.Verb.ABORDER))
	_use_button.pressed.connect(_select_verb.bind(VerbSystem.Verb.UTILISER))
	_create_verb_receiver()
	_refresh_verb_label()


func _create_verb_receiver() -> void:
	_verb_receiver = VerbReceiver.new()
	_verb_receiver.interactions = _build_interactions()
	add_child(_verb_receiver)


func _build_interactions() -> Array[InteractionDefinition]:
	var definitions: Array[InteractionDefinition] = []
	definitions.append(
		_create_definition(
			"hotspot_a",
			VerbSystem.Verb.OBSERVER,
			InteractionDefinition.ResultType.MONOLOGUE,
			"debug.hotspot_a.observe"
		)
	)
	definitions.append(
		_create_definition(
			"hotspot_b",
			VerbSystem.Verb.ABORDER,
			InteractionDefinition.ResultType.DIALOGUE,
			"debug.hotspot_b.approach"
		)
	)
	definitions.append(
		_create_definition(
			"hotspot_c",
			VerbSystem.Verb.UTILISER,
			InteractionDefinition.ResultType.FLAG,
			FLAG_KEY
		)
	)
	return definitions


func _create_definition(
	interactable_id: String,
	verb: VerbSystem.Verb,
	result_type: InteractionDefinition.ResultType,
	payload: String
) -> InteractionDefinition:
	var definition: InteractionDefinition = InteractionDefinition.new()
	definition.interactable_id = interactable_id
	definition.verb = verb as int
	definition.result_type = result_type
	definition.payload = payload
	return definition


func _select_verb(verb: VerbSystem.Verb) -> void:
	VerbSystem.select_verb(verb, CycleStateManager.current_cycle)
	_refresh_verb_label()


func _on_interactable_clicked(interactable_id: String) -> void:
	var selected_verb: VerbSystem.Verb = VerbSystem.selected_verb
	_log_action("Clicked %s with %s" % [interactable_id, VerbSystem.get_label(selected_verb)])
	if interactable_id == "hotspot_c" and selected_verb == VerbSystem.Verb.UTILISER:
		call_deferred("_log_flag_result")


func _on_inner_monologue_triggered(text_key: String) -> void:
	_log_action("MONOLOGUE → %s" % text_key)


func _on_dialogue_started(dialogue_id: String) -> void:
	_log_action("DIALOGUE → %s" % dialogue_id)


func _on_scene_change_requested(scene_id: String) -> void:
	_log_action("SCENE_CHANGE → %s" % scene_id)


func _log_flag_result() -> void:
	var is_set: bool = bool(GameFlags.get_flag(FLAG_KEY, false))
	_log_action("FLAG → %s = %s" % [FLAG_KEY, str(is_set)])


func _refresh_verb_label() -> void:
	var selected_verb: VerbSystem.Verb = VerbSystem.selected_verb
	_verb_label.text = "Selected verb: %s" % VerbSystem.get_label(selected_verb)


func _log_action(message: String) -> void:
	_event_log.append(message)
	if _event_log.size() > MAX_LOG_LINES:
		_event_log = _event_log.slice(_event_log.size() - MAX_LOG_LINES)
	_log_label.text = "Event log:\n%s" % "\n".join(_event_log)
	print("[verb_receiver_test] %s" % message)
