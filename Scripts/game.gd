extends Node

@export var level_scene_paths : Array[String]

var current_level_num := 0
var current_level_node : Node = null

func _ready() -> void:
	load_level(current_level_num)
	GameController.next_level.connect(to_next_level)
	GameController.kill_player.connect(reload_level)

func load_level(num : int):
	var level_scene = load(level_scene_paths[num])
	current_level_node = level_scene.instantiate()
	add_child(current_level_node)
	
func unload_level():
	current_level_node.queue_free()
	current_level_node = null

func reload_level():
	unload_level()
	load_level(current_level_num)

func to_next_level():
	unload_level()
	current_level_num += 1
	if current_level_num < level_scene_paths.size():
		load_level(current_level_num)
	else:
		print("cum")
