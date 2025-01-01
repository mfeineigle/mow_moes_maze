extends Area2D

@export var height: int = 1
var is_cut: bool = false


func _ready() -> void:
	$Uncut.visible = true
	$Cut.visible = false
	

func _on_area_shape_player_entered(_area_rid: RID,
									area: Area2D,
									_area_shape_index: int,
									_local_shape_index: int) -> void:
	if area.is_in_group("player") and area.current_tool == area.push_mower:
		mow()

func mow() -> void:
	if is_cut:
		return
	else:
		print("cut the grass")
		$Uncut.visible = false
		$Cut.visible = true
		is_cut = true
