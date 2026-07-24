extends Node3D

const SPEED := 3.0

func _process(delta: float) -> void:
	$lowpolysaw.rotation.x += delta * SPEED
