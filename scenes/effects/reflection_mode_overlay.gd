extends Control
## Full-screen Reflection Mode overlay.
## Place after world effects and before HUD so the shader captures gameplay only.


func _ready() -> void:
	ReflectionMode.sync_overlays()
