extends StaticBody2D


func _ready() -> void:
	GameEvents.changed_tool.connect(_on_changed_tool)

func _on_changed_tool(player) -> void:
	print("tooling up")
	match player.current_tool:
		player.push_mower:
			player.push_mower.visible = false
			player.weed_wacker.visible = true
			player.riding_mower.visible = false
			player.current_tool = player.weed_wacker
		player.weed_wacker:
			player.weed_wacker.visible = false
			player.push_mower.visible = false
			player.riding_mower.visible = true
			player.current_tool = player.riding_mower
		player.riding_mower:
			player.push_mower.visible = true
			player.weed_wacker.visible = false
			player.riding_mower.visible = false
			player.current_tool = player.push_mower


func _on_active_area_player_shape_entered(_area_rid: RID,
										  area: Area2D,
										  _area_shape_index: int,
										  _local_shape_index: int) -> void:
	if area.is_in_group("player"):
		print("TRUCK ENTER")
		print("player")
		area.at_truck = true
		print(area.at_truck)


func _on_active_area_player_shape_exited(_area_rid: RID,
										 area: Area2D,
										 _area_shape_index: int,
										 _local_shape_index: int) -> void:
	if area.is_in_group("player"):
		print("TRUCK EXIT")
		print("player")
		area.at_truck = false
		print(area.at_truck)
