extends StaticBody2D

func _ready() -> void:
	# Connect the changed_tool signal from GameEvents to our local handler
	GameEvents.changed_tool.connect(_on_changed_tool)


"""
Called whenever the changed_tool signal is emitted by GameEvents.
:param player: The player node that triggered the signal
"""
func _on_changed_tool(player) -> void:
	match player.current_tool:
		player.push_mower:
			# Hide the push_mower and display the weed_wacker
			player.push_mower.visible = false
			player.push_mower.disable()
			player.weed_wacker.visible = true
			player.weed_wacker.enable()
			player.current_tool = player.weed_wacker
		player.weed_wacker:
			# Hide the weed_wacker and display the riding_mower
			player.weed_wacker.visible = false
			player.weed_wacker.disable()
			player.riding_mower.visible = true
			player.riding_mower.enable()
			player.current_tool = player.riding_mower
		player.riding_mower:
			# Hide the riding_mower and display the push_mower
			player.riding_mower.visible = false
			player.riding_mower.disable()
			player.push_mower.visible = true
			player.push_mower.enable()
			player.current_tool = player.push_mower
		_:
			# Optionally handle an unexpected tool or do nothing
			push_warning("Unknown tool type encountered in _on_changed_tool.")


"""
Triggered when a player's shape enters the "active_area" (an Area2D).
This function is connected via the `area_entered` signal.
"""
func _on_active_area_player_shape_entered(
	_area_rid: RID,
	area: Area2D,
	_area_shape_index: int,
	_local_shape_index: int
) -> void:
	if area.is_in_group("player"):
		area.at_truck = true  # Setting a custom property on the player area


"""
Triggered when a player's shape exits the "active_area" (an Area2D).
This function is connected via the `area_exited` signal.
"""
func _on_active_area_player_shape_exited(
	_area_rid: RID,
	area: Area2D,
	_area_shape_index: int,
	_local_shape_index: int
) -> void:
	if area.is_in_group("player"):
		area.at_truck = false  # Resetting this custom property
