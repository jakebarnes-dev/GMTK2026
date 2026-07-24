extends Label

func _ready() -> void:
	GameController.next_level.connect(update_text)

func update_text():
	text = "Level " + str($"..".current_level_num + 2)	
