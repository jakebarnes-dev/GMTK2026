extends PathFollow3D

@export var SPEED := 1

var move = SPEED

func _process(delta: float) -> void:
	progress += move * delta
	if progress_ratio >= 1 or progress_ratio <= 0:
		move *= -1
