extends "../exterior_district.gd"
## Le Couloir — narrow alley shortcut, vulnerable (ISSUE-604).


func _configure_district() -> void:
	district_id = CycleStateManager.DISTRICT_CORRIDOR
	cycle = 0
	placeholder_color = Color(0.1, 0.11, 0.14, 1.0)
	rain_density = 0.9
	rain_speed = 2.4
	flicker_strength = 0.38
	flicker_speed = 3.6
