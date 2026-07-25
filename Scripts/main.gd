extends Node

@onready var main_menu_scene = preload("res://Scenes/main_menu.tscn")
@onready var game_scene = preload("res://Scenes/game.tscn")

var main_menu_node
var game_node

func _ready() -> void:
	main_menu_node = main_menu_scene.instantiate()
	game_node = game_scene.instantiate()
	add_child(main_menu_node)
	GameController.start_button_pressed.connect(switch_to_game)
	
func switch_to_game():
	remove_child(main_menu_node)
	add_child(game_node)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Fullscreen") and !OS.has_feature("web"):
		var mode = DisplayServer.window_get_mode()

		if mode == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
