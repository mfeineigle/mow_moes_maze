extends Tool

func move(dir) -> void:
	match dir:
		"move_left":
			position.x = -40
			position.y = 0
			rotation_degrees = 0
		"move_right":
			position.x = 32
			position.y = 0
			rotation_degrees = 180
		"move_up":
			position.x = 0
			position.y = -32
			rotation_degrees = 90
		"move_down":
			position.x = 0
			position.y = 32
			rotation_degrees = 270

func activate() -> int:
	return fuel_cost
