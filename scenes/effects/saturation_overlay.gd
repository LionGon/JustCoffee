extends Control
## Full-screen saturation vignette + desaturation + dissociation drift overlay
## (ISSUE-301 / ISSUE-302 / ISSUE-303).
## Place after gameplay art and before HUD so BackBufferCopy captures only the world layer.


func _ready() -> void:
	SaturationManager.apply_saturation()
