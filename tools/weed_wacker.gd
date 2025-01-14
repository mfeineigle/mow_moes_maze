extends Tool


func move(dir) -> void:
	match dir:
		"move_left":
			position.x = -20
			position.y = 16
			rotation_degrees = 75
		"move_right":
			position.x = 25
			position.y = 0
			rotation_degrees = -20
		"move_up":
			position.x = 0
			position.y = -35
			rotation_degrees = -95
		"move_down":
			position.x = 0
			position.y = 35
			rotation = 0

func activate() -> int:
	return fuel_cost
