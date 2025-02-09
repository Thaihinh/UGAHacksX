extends CharacterBody2D

enum States {IDLE, WALKING, JUMPING, FALLING, LANDING}

var arms: Texture2D = preload("res://player/player.png")
var no_arms: Texture2D = preload("res://player/player_no_arms.png")
var state: States = States.IDLE
var jumping: bool = false
var auto_melee: bool = false
var auto_ranged: bool = false
var attacking: bool = false
var attack_direction: int = 0
var ranged_projectile: PackedScene = preload("res://player/player_projectile/player_projectile.tscn")
var rng = RandomNumberGenerator.new()

const SPEED: float = 100.0
const JUMP_VELOCITY: float = -275

func _ready() -> void:
	$GuitarSprite.visible = false
	$RangedGuitarSprite.visible = false
	$RangedGuitarSprite.frame = rng.randi_range(0, 3)
	$GuitarSprite/MeleeAttack.monitorable = false

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
	if direction != 0:
		attack_direction = direction
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# Auto melee
	if Input.is_action_just_pressed("melee_attack"):
		auto_melee = true
	if Input.is_action_just_released("melee_attack"):
		auto_melee = false
	
	# Auto ranged
	if Input.is_action_just_pressed("ranged_attack"):
		auto_ranged = true
	if Input.is_action_just_released("ranged_attack"):
		auto_ranged = false
	
	# Attack implementation
	if auto_melee and not attacking:
		$PlayerSprite.texture = no_arms
		attacking = true
		if attack_direction > 0:
			$AttackAnimation.play("melee_attack_right")
		else:
			$AttackAnimation.play("melee_attack_left")
	elif auto_ranged and not attacking:
		$PlayerSprite.texture = no_arms
		attacking = true
		if attack_direction > 0:
			$AttackAnimation.play("ranged_attack_right")
		else:
			$AttackAnimation.play("ranged_attack_left")
	
	# Landing
	if is_on_floor() and state == States.FALLING:
		set_state(States.LANDING)
	
	if (velocity.x != 0):
		# Sprite Direction
		if velocity.x > 0:
			$PlayerSprite.scale.x = 1
		elif velocity.x < 0:
			$PlayerSprite.scale.x = -1
		
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
			$PlayerAnimation.play("idle")
		States.WALKING:
			$PlayerAnimation.play("walking")
		States.JUMPING:
			$PlayerAnimation.play("jump")
		States.FALLING:
			$PlayerAnimation.play("falling")
		States.LANDING:
			$PlayerAnimation.play("landing")

# Animation calls
func jump() -> void:
	velocity.y += JUMP_VELOCITY

func land() -> void:
	set_state(States.IDLE)

func attack_end() -> void:
	attacking = false
	if not auto_melee:
		$PlayerSprite.texture = arms

func ranged_attack_shoot() -> void:
	var projectile = ranged_projectile.instantiate()
	owner.add_child(projectile)
	$RangedGuitarSprite/RangedAudio.play()
	projectile.transform = $RangedGuitarSprite/NoteSpawn.global_transform

func ranged_attack_end() -> void:
	$RangedGuitarSprite.frame = rng.randi_range(0, 3)
	attacking = false
	if not auto_ranged:
		$RangedGuitarSprite.visible = false
		$PlayerSprite.texture = arms

func melee_sound() -> void:
	$GuitarSprite/MeleeAudio.play()

# Taking damage
func _on_hurtbox_body_entered(body: Node2D) -> void:
	if $Invincibility.is_stopped():
		$Hurtsound.play()
		$Invincibility.start()
		Global.health -= 1
