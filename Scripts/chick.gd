extends CharacterBody3D

const FOLLOW_DISTANCE : float = 0.5
const SPEED : float = 2.0
const GLIDE_VELOCITY : float = -0.5
const JUMP_VELOCITY : float = 5.0
const GRAVITY : float = 5.9
const JUMP_DELAY : float = 0.2

@export var formation_position : int = 0

signal kill_chick()

var facing_direction : Vector3
var jump_now = false

func _ready() -> void:
	GameController.jump.connect(player_jumped)
	self.kill_chick.connect(kill)
	GameController.kill_chick.connect(chick_killed)

func kill():
	GameController.kill_chick.emit(formation_position)
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
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = 0
		velocity.z = 0
	
	move_and_slide()

func _process(_delta: float) -> void:
	$Model.rotation.y = atan2(facing_direction.x, facing_direction.z) + deg_to_rad(180)

func _on_jump_timer_timeout() -> void:
	jump_now = true
