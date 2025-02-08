extends CharacterBody2D

enum States {IDLE, WALKING, JUMPING, FALLING, LANDING}

var state: States = States.IDLE
var jumping: bool = false
var coyote: bool = true

const SPEED: float = 150.0
const JUMP_VELOCITY: float = -250.0

func _physics_process(delta: float) -> void:
	# Gravity and falling
	if not is_on_floor():
		velocity += get_gravity() * delta
		set_state(States.FALLING)
	
	# Bunny hop implementation
	if Input.is_action_just_pressed("ui_accept"):
		jumping = true
	if Input.is_action_just_released("ui_accept"):
		jumping = false
	
	# Jumping
	if jumping and is_on_floor() and state != States.JUMPING and state != States.LANDING:
		set_state(States.JUMPING)

	# Movement
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# Landing
	if is_on_floor() and state == States.FALLING:
		set_state(States.LANDING)
	
	if (velocity.x != 0):
		# Sprite Direction
		if velocity.x > 0:
			$Sprite.scale.x = 1
		elif velocity.x < 0:
			$Sprite.scale.x = -1
		
		# Walking animation if grounded
		if is_on_floor() and state != States.JUMPING and state != States.LANDING:
			set_state(States.WALKING)
	else:
		# Idle animation if grounded
		if is_on_floor() and state != States.JUMPING and state != States.LANDING:
			set_state(States.IDLE)
	
	move_and_slide()

func set_state(new_state: States) -> void:
	# Avoid repeating animations
	if (new_state == state):
		return
	state = new_state
	match state:
		States.IDLE:
			$AnimationPlayer.play("idle")
		States.WALKING:
			$AnimationPlayer.play("walking")
		States.JUMPING:
			$AnimationPlayer.play("jump")
		States.FALLING:
			$AnimationPlayer.play("falling")
		States.LANDING:
			$AnimationPlayer.play("landing")

# Animation calls
func jump() -> void:
	velocity.y += JUMP_VELOCITY

func land() -> void:
	set_state(States.IDLE)
