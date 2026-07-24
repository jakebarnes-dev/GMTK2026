extends Label

func _ready() -> void:
	GameController.kill_chick.connect(update_text)

func update_text(_x):
	text = str(GameController.chicks+1)	
	scale.x = 2.1
	scale.y = 2.1
	label_settings.font_color = Color.RED

func _process(delta: float) -> void:
	scale.x = max(1.0, scale.x - delta * 3)
	scale.y = max(1.0, scale.y - delta * 3)
	if scale.x == 1.0:
		label_settings.font_color = Color.WHITE
