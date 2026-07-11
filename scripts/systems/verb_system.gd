class_name VerbSystem
extends RefCounted
## Ten custom verbs with cycle-gated availability (RULES.md §6.4).
## Never use Look At / Use / Talk To / Pick Up labels.

enum Verb {
	OBSERVER,
	ABORDER,
	ECOUTER,
	RETENIR,
	UTILISER,
	ALLER,
	EVITER,
	CEDER,
	FORCER,
	RECULER,
}

const VERB_LABELS_FR: Dictionary = {
	Verb.OBSERVER: "OBSERVER",
	Verb.ABORDER: "ABORDER",
	Verb.ECOUTER: "ÉCOUTER",
	Verb.RETENIR: "RETENIR",
	Verb.UTILISER: "UTILISER",
	Verb.ALLER: "ALLER",
	Verb.EVITER: "ÉVITER",
	Verb.CEDER: "CÉDER",
	Verb.FORCER: "FORCER",
	Verb.RECULER: "RECULER",
}

const VERB_LABELS_EN: Dictionary = {
	Verb.OBSERVER: "OBSERVE",
	Verb.ABORDER: "APPROACH",
	Verb.ECOUTER: "LISTEN",
	Verb.RETENIR: "HOLD BACK",
	Verb.UTILISER: "USE",
	Verb.ALLER: "GO",
	Verb.EVITER: "AVOID",
	Verb.CEDER: "YIELD",
	Verb.FORCER: "FORCE",
	Verb.RECULER: "RETREAT",
}

static var selected_verb: Verb = Verb.OBSERVER


static func get_label(verb: Verb, locale: String = "fr") -> String:
	if locale == "en":
		return VERB_LABELS_EN.get(verb, "UNKNOWN") as String
	return VERB_LABELS_FR.get(verb, "UNKNOWN") as String


static func get_available_verbs(cycle: int) -> Array[Verb]:
	var verbs: Array[Verb] = [
		Verb.OBSERVER,
		Verb.ABORDER,
		Verb.ECOUTER,
		Verb.RETENIR,
		Verb.UTILISER,
		Verb.ALLER,
		Verb.EVITER,
		Verb.FORCER,
		Verb.RECULER,
	]
	if cycle >= 1:
		verbs.insert(7, Verb.CEDER)
	return verbs


static func is_verb_greyed(verb: Verb, cycle: int, context: Dictionary = {}) -> bool:
	if context.get("force_reculer", false):
		return verb != Verb.RECULER
	if cycle >= 3 and verb == Verb.FORCER:
		return true
	if cycle >= 3 and verb == Verb.ABORDER:
		if context.get("npc_grey_aborder", false):
			return true
	return false


static func select_verb(verb: Verb, cycle: int = 0, context: Dictionary = {}) -> void:
	if is_verb_greyed(verb, cycle, context):
		return
	selected_verb = verb
	EventBus.verb_selected.emit(verb as int)


static func get_all_verbs() -> Array[Verb]:
	return [
		Verb.OBSERVER,
		Verb.ABORDER,
		Verb.ECOUTER,
		Verb.RETENIR,
		Verb.UTILISER,
		Verb.ALLER,
		Verb.EVITER,
		Verb.CEDER,
		Verb.FORCER,
		Verb.RECULER,
	]
