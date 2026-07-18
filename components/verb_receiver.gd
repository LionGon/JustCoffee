class_name VerbReceiver
extends Node
## Resolves verb+hotspot data and emits the resulting system request (ISSUE-202).
## This component deliberately does not depend on Dialogic or other presentation systems.


@export var interactions: Array[InteractionDefinition] = []


func _ready() -> void:
	EventBus.interactable_clicked.connect(_on_interactable_clicked)


## Resolves the first matching interaction and reports whether one was found.
func resolve(interactable_id: String, verb: VerbSystem.Verb) -> bool:
	for interaction: InteractionDefinition in interactions:
		if interaction.interactable_id != interactable_id:
			continue
		if interaction.verb != (verb as int):
			continue
		_dispatch(interaction)
		return true
	return false


func _on_interactable_clicked(interactable_id: String) -> void:
	var selected_verb: VerbSystem.Verb = VerbSystem.selected_verb
	resolve(interactable_id, selected_verb)


func _dispatch(interaction: InteractionDefinition) -> void:
	match interaction.result_type:
		InteractionDefinition.ResultType.DIALOGUE:
			EventBus.dialogue_started.emit(interaction.payload)
		InteractionDefinition.ResultType.MONOLOGUE:
			EventBus.inner_monologue_triggered.emit(interaction.payload)
		InteractionDefinition.ResultType.SCENE_CHANGE:
			EventBus.scene_change_requested.emit(interaction.payload)
		InteractionDefinition.ResultType.FLAG:
			GameFlags.set_flag(interaction.payload, true)
			# FLAG writes state only; it intentionally emits no follow-up presentation event.
		_:
			push_warning("Unknown interaction result type for '%s'." % interaction.interactable_id)
