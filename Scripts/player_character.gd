extends CharacterBody3D

const GRAVITY : float = 6.0
const GLIDE_VELOCITY : float = -0.5
const JUMP_VELOCITY : float = 5.0
const MOVEMENT_ACC : float = 6.0
const MOVEMENT_SPEED : float = 3.0
const TURN_SPEED : float = 5.0
const GLIDE_TURN_SPEED : float = 1
const CHICK_SCENE = preload("res://Scenes/chick.tscn")

var facing_direction : Vector3 = Vector3.BACK
var turn_speed : float = TURN_SPEED

func _ready() -> void:
	for i in GameController.chicks:
		print(i)
		var chick_node = CHICK_SCENE.instantiate()
		add_sibling.call_deferred(chick_node)
		chick_node.formation_position = i
		chick_node.position.y += 0.5

func _physics_process(delta: float) -> void:
	# Jump / Glide
	turn_speed = TURN_SPEED
	if is_on_floor():
		if $GlideSound.playing:
			$GlideSound.stop()
		if Input.is_action_just_pressed("jump"):
			velocity.y += JUMP_VELOCITY
			GameController.jump.emit()
			$JumpSound.pitch_scale = randf_range(0.9,1.1)
			$JumpSound.play()
	else:
		if velocity.y < 0 and Input.is_action_pressed("jump"):
			velocity.y = GLIDE_VELOCITY
			turn_speed = GLIDE_TURN_SPEED
			if not $GlideSound.playing:
				$GlideSound.play()
		else:
			if $GlideSound.playing:
				$GlideSound.stop()
			velocity.y -= GRAVITY * delta
	
	# Movement
	var input_vector : Vector2 = Input.get_vector("right","left","back","forward")
	var target_direction := Vector3(input_vector.x, 0.0, input_vector.y)
	if target_direction.length() > 0.1:
		var target_angle := atan2(target_direction.x, target_direction.z)
		var current_angle := atan2(facing_direction.x, facing_direction.z)
		var new_angle := lerp_angle(current_angle, target_angle, turn_speed * delta)
		facing_direction = Vector3(sin(new_angle), 0.0, cos(new_angle))
		var target_speed := MOVEMENT_SPEED * input_vector.length()
		velocity.x = move_toward(velocity.x, facing_direction.x * target_speed, MOVEMENT_ACC * delta)
		velocity.z = move_toward(velocity.z, facing_direction.z * target_speed, MOVEMENT_ACC * delta)
	else:
		velocity.x = move_toward(velocity.x, 0.0, MOVEMENT_ACC * delta)
		velocity.z = move_toward(velocity.z, 0.0, MOVEMENT_ACC * delta)
	
	move_and_slide()

func _process(_delta: float) -> void:
	# Animation
	$Model.rotation.y = atan2(facing_direction.x, facing_direction.z)
	if is_on_floor():
		if velocity.length() > 0.1:
			$Model.animate.emit("walk")
			if not $WalkSound.playing:
				$WalkSound.pitch_scale = randf_range(0.9,1.1)
				$WalkSound.play()
		else:
			$Model.animate.emit("idle")
	else:
		if velocity.y < 0 and Input.is_action_pressed("jump"):
			$Model.animate.emit("glide")
		else:
			$Model.animate.emit("flap")
		
	
	GameController.player_position = global_position
	if global_position.y < -2.0:
		GameController.kill_player.emit()
