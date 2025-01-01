extends Label

func _ready() -> void:
	GameEvents.fuel_changed.connect(_fuel_changed)

func _fuel_changed(fuel_level) -> void:
	text = str(fuel_level)
