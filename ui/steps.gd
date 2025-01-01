extends Label

var steps: int = 0

func _ready() -> void:
	GameEvents.steps_changed.connect(_steps_changed)

func _steps_changed() -> void:
	steps += 1
	text = str(steps)
