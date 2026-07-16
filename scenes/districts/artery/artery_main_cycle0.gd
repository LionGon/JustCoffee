extends "../exterior_district.gd"
## L'Artère — commercial street, maximum exposure (ISSUE-604).


func _configure_district() -> void:
	district_id = CycleStateManager.DISTRICT_ARTERY
	cycle = 0
	placeholder_color = Color(0.24, 0.2, 0.16, 1.0)
	rain_density = 0.85
	rain_speed = 2.9
	flicker_strength = 0.32
	flicker_speed = 4.2
