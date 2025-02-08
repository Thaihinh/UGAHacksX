extends CharacterBody2D

enum States {IDLE, WALKING, JUMPING, FALLING}

var state: States = States.IDLE
var attacking: bool = false

const SPEED: float = 300.0
const JUMP_VELOCITY: float = -400.0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()

func set_state(new_state: States) -> void:
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
