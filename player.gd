extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var ray = $RayCast2D

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

func _unhandled_input(event):
	if event.is_action_pressed("quit"):
		get_tree().quit()

func _process(_delta: float) -> void:
	if moving:
		pass
	else:
		for dir in inputs.keys():
			if Input.is_action_pressed(dir):
				move(dir)

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
	else:
		print("hit something")
	print(position)
