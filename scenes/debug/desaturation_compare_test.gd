extends Control
## ISSUE-302 (#20) — visual comparison for luminance desaturation + vignette.
##
## ISSUE-302 is fulfilled via the combined `saturation_vignette.gdshader` applied on a
## `ColorRect` in `BackBufferCopy` mode (ISSUE-301 vignette + ISSUE-302 desaturation in
## one pass). Chaining in a single shader follows RULES.md §13 — no SubViewport
## post-process, stable 1080p cost.
##
## Dev-only: buttons jump to fixed levels for screenshot comparison. Production never
## exposes numeric saturation (SaturationManager drives the same shader uniformly).


@onready var _level_label: Label = $VBox/LevelLabel


func _ready() -> void:
	$VBox/LevelRow/Level0Button.pressed.connect(_set_level.bind(0.0))
	$VBox/LevelRow/Level5Button.pressed.connect(_set_level.bind(0.5))
	$VBox/LevelRow/Level85Button.pressed.connect(_set_level.bind(0.85))
	$VBox/LevelRow/Level100Button.pressed.connect(_set_level.bind(1.0))
	_set_level(0.0)


func _set_level(level: float) -> void:
	SaturationManager.saturation_level = level
	SaturationManager.apply_saturation()
	var band: String = "calm"
	if level >= 0.85:
		band = "dissociation"
	elif level >= 0.5:
		band = "mid anxiety"
	_level_label.text = (
		"Band: %s — saturation_level = %.2f (0.85 = dissociation threshold)"
		% [band, level]
	)
