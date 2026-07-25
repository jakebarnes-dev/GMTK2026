extends Button

func _on_pressed() -> void:
	GameController.reset_game.emit()
	get_tree().reload_current_scene()
