extends Tool

func move(dir) -> void:
	match dir:
		"move_left":
			position.x = -35
			position.y = 0
			rotation = 0
		"move_right":
			position.x = 35
			position.y = 0
			rotation = PI
		"move_up":
			position.x = 0
			position.y = -45
			rotation = PI/2
		"move_down":
			position.x = 0
			position.y = 45
			rotation = -PI/2
