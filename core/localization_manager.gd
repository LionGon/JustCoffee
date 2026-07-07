extends Node
## FR/EN toggle and string retrieval for non-Dialogic UI (RULES.md §12).
##
## Dialogic locale sync (ISSUE-701): after installing Dialogic, call
## `DialogicUtil.set_current_locale(LocalizationManager.get_dialogic_locale())`
## whenever `locale_changed` fires, or from DialogueManager if using Dialogic 2's
## translation settings — keep the same `"fr"` / `"en"` codes as this manager.

signal locale_changed(new_locale: String)

const LOCALE_FR: String = "fr"
const LOCALE_EN: String = "en"
const SUPPORTED_LOCALES: Array[String] = [LOCALE_FR, LOCALE_EN]

const _TABLE_PATHS: Dictionary = {
	LOCALE_FR: "res://data/localization/ui_fr.csv",
	LOCALE_EN: "res://data/localization/ui_en.csv",
}

var _locale: String = LOCALE_FR
var _tables: Dictionary = {}


func _ready() -> void:
	_load_all_tables()


func set_locale(locale: String) -> void:
	if locale not in SUPPORTED_LOCALES:
		push_warning("LocalizationManager: unsupported locale '%s'" % locale)
		return
	if locale == _locale:
		return
	_locale = locale
	locale_changed.emit(_locale)


func get_locale() -> String:
	return _locale


## Returns the active locale code for Dialogic translation sync.
func get_dialogic_locale() -> String:
	return _locale


## UI string lookup by key. ISSUE-106 specifies `tr()`; Godot reserves `Object.tr()` on
## autoloads, so callers use `get_text(key)` instead.
func get_text(key: String) -> String:
	var table: Dictionary = _tables.get(_locale, {}) as Dictionary
	if table.has(key):
		return table[key] as String
	push_warning("LocalizationManager: missing key '%s' for locale '%s'" % [key, _locale])
	return key


func _load_all_tables() -> void:
	for locale: String in SUPPORTED_LOCALES:
		var path: String = _TABLE_PATHS[locale]
		_tables[locale] = _load_csv_table(path)


func _load_csv_table(path: String) -> Dictionary:
	var table: Dictionary = {}
	if not FileAccess.file_exists(path):
		push_error("LocalizationManager: missing table %s" % path)
		return table

	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("LocalizationManager: cannot open %s" % path)
		return table

	var is_header: bool = true
	while not file.eof_reached():
		var line: String = file.get_line().strip_edges()
		if line.is_empty() or line.begins_with("#"):
			continue
		if is_header:
			is_header = false
			continue
		var parts: PackedStringArray = line.split(",", false, 1)
		if parts.size() < 2:
			continue
		table[parts[0]] = parts[1]

	return table
