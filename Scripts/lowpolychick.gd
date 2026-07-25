extends Node3D

@onready var animation = $AnimationPlayer

signal animate(anim_name : String)

func _ready() -> void:
	animation.play("chicken/idle")
	animate.connect(play_animation)
	
func play_animation(anim_name : String):
	animation.play("chicken/"+anim_name)
