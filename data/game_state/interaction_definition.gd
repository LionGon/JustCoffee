class_name InteractionDefinition
extends Resource
## Verb+hotspot → action (ISSUE-202). Data only — no presentation logic.


enum ResultType { DIALOGUE, MONOLOGUE, SCENE_CHANGE, FLAG }

@export var interactable_id: String = ""
@export var verb: int = 0  # VerbSystem.Verb as int
@export var result_type: ResultType = ResultType.MONOLOGUE
@export var payload: String = ""
