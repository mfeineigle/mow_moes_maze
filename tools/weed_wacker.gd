extends Tool


func move(dir) -> void:
	match dir:
		"move_left":
			position.x = -20
			position.y = 16
			rotation = deg_to_rad(75)
		"move_right":
			position.x = 25
			position.y = 0
			rotation = deg_to_rad(-20)
		"move_up":
			position.x = 0
			position.y = -35
			rotation = deg_to_rad(-95)
		"move_down":
			position.x = 0
			position.y = 35
			rotation = 0

func activate() -> int:
	get_overlapping_areas()[-1].mow()
	return fuel_cost
