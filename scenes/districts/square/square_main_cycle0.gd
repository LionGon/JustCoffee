extends "../exterior_district.gd"
## La Place — open square, false decompression (ISSUE-604).


func _configure_district() -> void:
	district_id = CycleStateManager.DISTRICT_SQUARE
	cycle = 0
	placeholder_color = Color(0.15, 0.17, 0.21, 1.0)
	rain_density = 0.75
	rain_speed = 3.0
	flicker_strength = 0.26
	flicker_speed = 3.8
