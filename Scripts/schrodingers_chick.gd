extends Node3D

@export var chicken_number : int

func _ready() -> void:
	if chicken_number+1 <= GameController.chicks:
		visible = true
	else:
		visible = false
