extends Node3D

const VISIBILITY_BUFFER_Z := 2
const VISIBILITY_BUFFER_X := 1

func _process(_delta: float) -> void:
	if GameController.player_position.z >= global_position.z + VISIBILITY_BUFFER_Z and abs(GameController.player_position.x - global_position.x) <= VISIBILITY_BUFFER_X:
		visible = false
	else:
		visible = true
