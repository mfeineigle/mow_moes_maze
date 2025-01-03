extends StaticBody2D

# Called when the node is added to the scene.
func _ready() -> void:
    # Connect the changed_tool signal from GameEvents to our local handler
    GameEvents.changed_tool.connect(_on_changed_tool)


"""
Called whenever the changed_tool signal is emitted by GameEvents.

:param player: The player node that triggered the signal, presumably 
               containing references to push_mower and weed_wacker, etc.
"""
func _on_changed_tool(player) -> void:
	print("tooling up")
	match player.current_tool:
		player.push_mower:
			# Hide the push_mower and display the weed_wacker
			player.push_mower.visible = false
			player.weed_wacker.visible = true
			player.riding_mower.visible = false
			player.current_tool = player.weed_wacker
		player.weed_wacker:
			# Hide the weed_wacker and display the push_mower
			player.weed_wacker.visible = false
			player.push_mower.visible = false
			player.riding_mower.visible = true
			player.current_tool = player.riding_mower
		player.riding_mower:
			player.push_mower.visible = true
			player.weed_wacker.visible = false
			player.riding_mower.visible = false
			player.current_tool = player.push_mower
		_:
			# Optionally handle an unexpected tool or do nothing
			push_warning("Unknown tool type encountered in _on_changed_tool.")


"""
Triggered when a player's shape enters the "active_area" (an Area2D).
This function is likely connected via the `body_entered` or `area_entered` signal.

:param _area_rid:         The RID of the shape that triggered this event (unused).
:param area:              The Area2D or PhysicsBody2D that has entered.
:param _area_shape_index: The shape index within `area` (unused).
:param _local_shape_index:The shape index of the local area (unused).
"""
func _on_active_area_player_shape_entered(
    _area_rid: RID,
    area: Area2D,
    _area_shape_index: int,
    _local_shape_index: int
) -> void:
    if area.is_in_group("player"):
        print("TRUCK ENTER")
        area.at_truck = true  # Setting a custom property on the player area
        print(area.at_truck)


"""
Triggered when a player's shape exits the "active_area" (an Area2D).
This function is likely connected via the `body_exited` or `area_exited` signal.

:param _area_rid:         The RID of the shape that triggered this event (unused).
:param area:              The Area2D or PhysicsBody2D that has exited.
:param _area_shape_index: The shape index within `area` (unused).
:param _local_shape_index:The shape index of the local area (unused).
"""
func _on_active_area_player_shape_exited(
    _area_rid: RID,
    area: Area2D,
    _area_shape_index: int,
    _local_shape_index: int
) -> void:
    if area.is_in_group("player"):
        print("TRUCK EXIT")
        area.at_truck = false  # Resetting this custom property
        print(area.at_truck)
