extends Control
## Full-screen saturation vignette overlay (ISSUE-301).
## Place after gameplay art and before HUD so BackBufferCopy captures only the world layer.


func _ready() -> void:
	SaturationManager.apply_saturation()
