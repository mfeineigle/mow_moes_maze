extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var ray = $RayCast2D
@onready var tools: Node = $Tools
@onready var push_mower: Area2D = $Tools/Push_Mower
@onready var weed_wacker: Area2D = $Tools/Weed_Wacker
@onready var riding_mower: Area2D = $Tools/Riding_Mower
@onready var current_tool: Tool

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
			  "move_down": Vector2.DOWN}

func _ready():
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size/2
	current_tool = push_mower
	push_mower.visible = true
	for tool in tools.get_children():
		tool.move("move_left")
	print(current_tool)
	

func _unhandled_input(event):
	if event.is_action_pressed("quit"):
		get_tree().quit()
	if current_tool == weed_wacker and event.is_action_pressed("wack_weeds"):
		fuel_level += current_tool.activate()
		GameEvents.fuel_changed.emit(fuel_level)
	if at_truck and event.is_action_pressed("change_tool"):
		GameEvents.changed_tool.emit(self)
		print("changing")

func _process(_delta: float) -> void:
	if moving:
		pass
	else:
		for dir in inputs.keys():
			if Input.is_action_pressed(dir):
				move(dir)
				for tool in tools.get_children():
					tool.move(dir)
				

func move(dir):
	match dir:
		"move_left":
			animation_player.play("move_left")
		"move_right":
			animation_player.play("move_right")
		"move_up":
			animation_player.play("move_up")
		"move_down":
			animation_player.play("move_down")
	ray.target_position = inputs[dir] * tile_size
	ray.force_raycast_update()
	if not ray.is_colliding():
		var tween = create_tween()
		tween.tween_property(self,
							 "position",
							 position + inputs[dir] * tile_size,
							 1.0/animation_speed).set_trans(Tween.TRANS_SINE)
		moving = true
		await tween.finished
		moving = false
		stamina_level += current_tool.stamina_cost
		GameEvents.stamina_changed.emit(stamina_level)
		if current_tool != weed_wacker:
			fuel_level += current_tool.activate()
			GameEvents.fuel_changed.emit(fuel_level)
		GameEvents.steps_changed.emit()
	else:
		print("hit something")
