extends Label

func _ready() -> void:
	GameEvents.stamina_changed.connect(_stamina_changed)

func _stamina_changed(stamina_level) -> void:
	text = str(stamina_level)
