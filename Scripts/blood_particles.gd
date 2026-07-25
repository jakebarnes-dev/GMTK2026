extends GPUParticles3D

func _ready() -> void:
	emitting = true
	print("spurt")
	$AudioStreamPlayer3D.pitch_scale = randf_range(0.9,1.1)
	
func _process(_delta: float) -> void:
	if not emitting:
		queue_free()
