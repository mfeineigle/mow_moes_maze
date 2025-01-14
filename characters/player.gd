extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var left_ray: RayCast2D = $rays/left_ray
@onready var center_ray: RayCast2D = $rays/center_ray
@onready var rear_ray: RayCast2D = $rays/rear_ray
@onready var right_ray: RayCast2D = $rays/right_ray
@onready var tools: Node = $Tools
@onready var push_mower: Area2D = $Tools/Push_Mower
@onready var weed_wacker: Area2D = $Tools/Weed_Wacker
@onready var riding_mower: Area2D = $Tools/Riding_Mower
@onready var current_tool: Tool

var delay: int = 0
var cur_dir: Vector2 = Vector2.LEFT
var last_dir: Vector2 = Vector2.LEFT
var at_truck: bool = false
var stamina_level: int = 0
var fuel_level: int = 0
var animation_speed: int = 8
var moving: bool = false
var tile_size = 64
var inputs = {"move_right": Vector2.RIGHT,
			  "move_left": Vector2.LEFT,
			  "move_up": Vector2.UP,
			  "move_down": Vector2.DOWN,
			  "strafe_right": Vector2.RIGHT,
			  "strafe_left": Vector2.LEFT,
			  "strafe_up": Vector2.UP,
			  "strafe_down": Vector2.DOWN,
			}

func _ready():
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size/2
	for tool in tools.get_children():
		tool.move("move_left")
		tool.disable()
	current_tool = push_mower
	push_mower.enable()
	push_mower.visible = true
	print(current_tool)
	

func _unhandled_input(event):
	if event.is_action_pressed("quit"):
		get_tree().quit()
	if current_tool == weed_wacker and event.is_action_pressed("wack_weeds"):
		fuel_level += current_tool.activate()
		GameEvents.fuel_changed.emit(fuel_level)
	if at_truck and event.is_action_pressed("change_tool"):
		GameEvents.changed_tool.emit(self)


func _process(_delta: float) -> void:
	delay += 1
	if moving:
		pass
	else:
		for dir in inputs.keys():
			if Input.is_action_pressed(dir, true) and delay >= 20:
				delay = 0
				move(dir)
				for tool in tools.get_children():
					tool.move(dir)
				


func move(dir):
	last_dir = cur_dir
	_move_rays(dir)

	match dir:
		"move_left":
			animation_player.play("move_left")
			cur_dir = Vector2.LEFT
		"move_right":
			animation_player.play("move_right")
			cur_dir = Vector2.RIGHT
		"move_up":
			animation_player.play("move_up")
			cur_dir = Vector2.UP
		"move_down":
			animation_player.play("move_down")
			cur_dir = Vector2.DOWN
		"strafe_left":
			_strafe()
		"strafe_right":
			_strafe()
		"strafe_up":
			_strafe()
		"strafe_down":
			_strafe()

	if dir == "move_up" and last_dir == Vector2.LEFT and current_tool == push_mower:
		if not right_ray.is_colliding():
			_update_move(dir)
	elif dir == "move_up" and last_dir == Vector2.RIGHT and current_tool == push_mower:
		if not left_ray.is_colliding():
			_update_move(dir)
	elif dir == "move_up" and last_dir == Vector2.DOWN and current_tool == push_mower:
		if not rear_ray.is_colliding():
			_update_move(dir)
	elif dir == "move_up" and current_tool == push_mower:
		if not center_ray.is_colliding():
			_update_move(dir)

	if dir == "move_down" and last_dir == Vector2.LEFT and current_tool == push_mower:
		if not left_ray.is_colliding():
			_update_move(dir)
	elif dir == "move_down" and last_dir == Vector2.RIGHT and current_tool == push_mower:
		if not right_ray.is_colliding():
			_update_move(dir)
	elif dir == "move_down" and last_dir == Vector2.UP and current_tool == push_mower:
		if not rear_ray.is_colliding():
			_update_move(dir)
	elif dir == "move_down" and current_tool == push_mower:
		if not center_ray.is_colliding():
			_update_move(dir)

	if dir == "move_left" and last_dir == Vector2.UP and current_tool == push_mower:
		if not left_ray.is_colliding():
			_update_move(dir)
	elif dir == "move_left" and last_dir == Vector2.DOWN and current_tool == push_mower:
		if not right_ray.is_colliding():
			_update_move(dir)
	elif dir == "move_left" and last_dir == Vector2.RIGHT and current_tool == push_mower:
		if not rear_ray.is_colliding():
			_update_move(dir)
	elif dir == "move_left" and current_tool == push_mower:
		if not center_ray.is_colliding():
			_update_move(dir)

	if dir == "move_right" and last_dir == Vector2.UP and current_tool == push_mower:
		if not right_ray.is_colliding():
			_update_move(dir)
	elif dir == "move_right" and last_dir == Vector2.DOWN and current_tool == push_mower:
		if not left_ray.is_colliding():
			_update_move(dir)
	elif dir == "move_right" and last_dir == Vector2.LEFT and current_tool == push_mower:
		if not rear_ray.is_colliding():
			_update_move(dir)
	elif dir == "move_right" and current_tool == push_mower:
		if not center_ray.is_colliding():
			_update_move(dir)


func _move_rays(dir) -> void:
	center_ray.target_position = inputs[dir] * tile_size
	rear_ray.target_position = center_ray.target_position * -1
	left_ray.target_position = center_ray.target_position
	left_ray.rotation_degrees = -90
	right_ray.target_position = center_ray.target_position
	right_ray.rotation_degrees = 90


func _strafe() -> void:
	if cur_dir == Vector2.UP:
		animation_player.play("move_up")
	elif cur_dir == Vector2.DOWN:
		animation_player.play("move_down")
	elif cur_dir == Vector2.LEFT:
		animation_player.play("move_left")
	elif cur_dir == Vector2.RIGHT:
		animation_player.play("move_right")


func _update_move(dir) -> void:
	_move_tween(dir)
	_update_stamina()
	_update_fuel()
	_update_steps()


func _move_tween(dir) -> void:
	var tween = create_tween()
	tween.tween_property(self,
						 "position",
						 position + inputs[dir] * tile_size,
						 1.0/animation_speed).set_trans(Tween.TRANS_SINE)
	moving = true
	await tween.finished
	moving = false


func _update_stamina() -> void:
	stamina_level += current_tool.stamina_cost
	GameEvents.stamina_changed.emit(stamina_level)


func _update_fuel() -> void:
	if current_tool != weed_wacker:
		fuel_level += current_tool.activate()
		GameEvents.fuel_changed.emit(fuel_level)


func _update_steps() -> void:
	GameEvents.steps_changed.emit()
