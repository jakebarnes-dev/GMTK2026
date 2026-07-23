extends Area3D

func _on_body_entered(body: Node3D) -> void:
	if body.collision_layer == (1 << (2 - 1)):
		GameController.kill_player.emit()
	elif body.collision_layer == (1 << (5 - 1)):
		body.kill_chick.emit()
