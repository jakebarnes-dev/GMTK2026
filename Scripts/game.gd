extends Node

@export var level_scene_paths : Array[String]

var current_level_num := 0
var current_level_node : Node = null

func _ready() -> void:
	load_level(current_level_num)
	GameController.next_level.connect(to_next_level)
	GameController.kill_player.connect(reload_level)
	$StartSound.play()

func load_level(num : int):
	var level_scene = load(level_scene_paths[num])
	current_level_node = level_scene.instantiate()
	add_child(current_level_node)
	
func unload_level():
	current_level_node.queue_free()
	current_level_node = null

func reload_level():
	unload_level()
	$DeathSound.play()
	GameController.kill_chick.emit(0)
	if GameController.chicks < 0:
		var win_scene = load("res://Scenes/win_screen.tscn")
		var win_scene_node = win_scene.instantiate()
		add_child(win_scene_node)
		$NumberLabel.visible = false
		$SurvivorsLabel.visible = false
		$LevelLabel.visible = false
	else:
		load_level(current_level_num)

func to_next_level():
	unload_level()
	current_level_num += 1
	$NextLevelSound.play()
	if current_level_num < level_scene_paths.size():
		load_level(current_level_num)
	else:
		var win_scene = load("res://Scenes/win_screen.tscn")
		var win_scene_node = win_scene.instantiate()
		add_child(win_scene_node)
		GameController.win_game.emit()
		$NumberLabel.visible = false
		$SurvivorsLabel.visible = false
		$LevelLabel.visible = false
