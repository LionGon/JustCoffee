extends Control
## ISSUE-302 (#20) / ISSUE-303 (#21) — visual comparison for desaturation, vignette, drift.
##
## Combined `saturation_vignette.gdshader` on a `ColorRect` in `BackBufferCopy` mode
## (ISSUE-301–303 in one pass). RULES.md §13 — no SubViewport post-process.
##
## At ≥0.85, `dissociation_active` enables ±3px sine sample drift (still playable).
## Dev-only: buttons jump to fixed levels. Production never exposes numeric saturation.


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
	var drift_note: String = "drift off"
	if level >= 0.85:
		band = "dissociation"
		drift_note = "±3px drift on"
	elif level >= 0.5:
		band = "mid anxiety"
	_level_label.text = (
		"Band: %s — saturation_level = %.2f — %s (threshold 0.85)"
		% [band, level, drift_note]
	)
