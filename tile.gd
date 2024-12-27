extends Area2D

@export var height: int = 1
var is_cut: bool = false

func _ready() -> void:
	$Uncut.visible = true
	$Cut.visible = false
	
func _on_player_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if is_cut:
			return
		else:
			print("cut the grass")
			$Uncut.visible = false
			$Cut.visible = true
			is_cut = true
