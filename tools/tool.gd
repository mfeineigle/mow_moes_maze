extends Area2D
class_name Tool

## Cost per tile traversed
@export var stamina_cost: int

@export var fuel_cost: int

# each tool should have a move function
# orients the tool in the correct dir
#func move(dir) -> void:

@onready var collision: CollisionShape2D = $CollisionShape2D

func disable() -> void:
	collision.disabled = true
	
func enable() -> void:
	collision.disabled = false
	
func activate() -> int:
	return 0
