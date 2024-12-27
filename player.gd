extends CharacterBody2D

func _physics_process(delta):
	if Input.is_action_pressed("move_left"):
		position.x -= 8
	if Input.is_action_pressed("move_right"):
		position.x += 8
	if Input.is_action_pressed("move_up"):
		position.y -= 8
	if Input.is_action_pressed("move_down"):
		position.y += 8
	if Input.is_action_pressed("quit"):
		get_tree().quit()
