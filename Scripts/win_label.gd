extends Label

@export_multiline var win_texts : Array[String]
@export_multiline var lost_text : String

func _ready() -> void:
	if GameController.chicks >= 0:
		text = win_texts[GameController.chicks]
	else:
		text = lost_text
