extends Area2D
class_name Tool

## Cost per tile traversed
@export var stamina_cost: int

@export var fuel_cost: int

# each tool should have a move function
# orients the tool in the correct dir
#func move(dir) -> void:

func activate() -> int:
	return 0
