extends Control
## Dev scene: verify LocalizationManager FR/EN toggle (ISSUE-106 acceptance).

@onready var _sample_label: Label = $VBox/SampleLabel
@onready var _locale_label: Label = $VBox/LocaleLabel
@onready var _toggle_button: Button = $VBox/ToggleButton


func _ready() -> void:
	LocalizationManager.locale_changed.connect(_on_locale_changed)
	_toggle_button.pressed.connect(_on_toggle_pressed)
	_refresh_labels()


func _on_toggle_pressed() -> void:
	var next_locale: String = "en" if LocalizationManager.get_locale() == "fr" else "fr"
	LocalizationManager.set_locale(next_locale)


func _on_locale_changed(_new_locale: String) -> void:
	_refresh_labels()


func _refresh_labels() -> void:
	_locale_label.text = "Locale: %s" % LocalizationManager.get_locale()
	_sample_label.text = "%s | %s | %s" % [
		LocalizationManager.get_text("boot.title"),
		LocalizationManager.get_text("district.threshold"),
		LocalizationManager.get_text("save.slot"),
	]
