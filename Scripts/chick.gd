extends CharacterBody3D

const FOLLOW_DISTANCE : float = 0.4
const SPEED : float = 3.0
const GLIDE_VELOCITY : float = -0.5
const JUMP_VELOCITY : float = 5.1
const GRAVITY : float = 5.9
const JUMP_DELAY : float = 0.14
const MOVEMENT_ACC : float = 12.0

@export var formation_position : int = 0

signal kill_chick()

var facing_direction : Vector3
var jump_now = false

var blood_particles_scene = preload("res://Scenes/blood_particles.tscn")

func _ready() -> void:
	GameController.jump.connect(player_jumped)
	self.kill_chick.connect(kill)
	GameController.kill_chick.connect(chick_killed)

func kill():
	GameController.kill_chick.emit(formation_position)
	blood()
	queue_free()

func chick_killed(form_pos : int):
	if formation_position > form_pos:
		formation_position -= 1

func player_jumped():
	$JumpTimer.wait_time = JUMP_DELAY * (formation_position+1)
	$JumpTimer.start()

func _physics_process(delta: float) -> void:
	# Jump / Glide
	if is_on_floor():
		if jump_now:
			velocity.y += JUMP_VELOCITY
			jump_now = false
	else:
		if velocity.y < 0 and Input.is_action_pressed("jump"):
			velocity.y = GLIDE_VELOCITY
		else:
			velocity.y -= GRAVITY * delta
	
	# Movement
	var target_position = GameController.player_position
	target_position.y = 0
	var my_position = global_position
	my_position.y = 0
	if my_position.distance_to(target_position) > FOLLOW_DISTANCE * (formation_position+1) + 0.2:
		var direction = my_position.direction_to(target_position)
		facing_direction = direction
		velocity.x = move_toward(velocity.x, direction.x * SPEED, MOVEMENT_ACC * delta)
		velocity.z = move_toward(velocity.z, direction.z * SPEED, MOVEMENT_ACC * delta)
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
		else:
			$Model.animate.emit("idle")
	else:
		if velocity.y < 0 and Input.is_action_pressed("jump"):
			$Model.animate.emit("glide")
		else:
			$Model.animate.emit("flap")
			
	if global_position.y < -3.0:
		kill_chick.emit()

func _on_jump_timer_timeout() -> void:
	jump_now = true

func blood():
	var blood_particles_node = blood_particles_scene.instantiate()
	add_sibling(blood_particles_node)
	blood_particles_node.global_position = global_position
