extends Control
## Dev scene: run locale-paired Dialogic sample timelines (ISSUE-701 acceptance).

const SAMPLE_RELATIVE_PATH: String = "cycle_0/sample_greeting.dtl"

@onready var _status_label: Label = $VBox/StatusLabel
@onready var _locale_label: Label = $VBox/LocaleLabel


func _ready() -> void:
	$VBox/RunTimelineButton.pressed.connect(_on_run_timeline_pressed)
	$VBox/ToggleLocaleButton.pressed.connect(_on_toggle_locale_pressed)

	if Engine.get_main_loop() != null:
		var dialogic: Node = get_tree().root.get_node_or_null("Dialogic")
		if dialogic != null and dialogic.has_signal("timeline_ended"):
			dialogic.timeline_ended.connect(_on_timeline_ended)

	_refresh()


func _on_toggle_locale_pressed() -> void:
	var next_locale: String = "en" if LocalizationManager.get_locale() == "fr" else "fr"
	LocalizationManager.set_locale(next_locale)
	_refresh()


func _on_run_timeline_pressed() -> void:
	var dialogic: Node = get_tree().root.get_node_or_null("Dialogic")
	if dialogic == null:
		_status_label.text = "Dialogic autoload missing — enable plugin in Project Settings."
		return

	DialogicBridge.sync_all()
	var timeline_path: String = DialogicBridge.get_timeline_path(SAMPLE_RELATIVE_PATH)
	if not ResourceLoader.exists(timeline_path):
		_status_label.text = "Missing timeline: %s" % timeline_path
		return

	_status_label.text = "Running: %s" % timeline_path
	dialogic.call("start", timeline_path)


func _on_timeline_ended() -> void:
	_status_label.text = "Timeline finished — %s" % DialogicBridge.get_timeline_path(SAMPLE_RELATIVE_PATH)
	_refresh()


func _refresh() -> void:
	_locale_label.text = "Locale: %s | Path: %s" % [
		LocalizationManager.get_locale(),
		DialogicBridge.get_timeline_path(SAMPLE_RELATIVE_PATH),
	]
