extends CharacterBody2D

const SPEED = 60
const JUMP_VELOCITY = -300

var direction = 1
var player_detected = false

@onready var raycastright: RayCast2D = $raycastright
@onready var raycastleft: RayCast2D = $raycastleft

func _ready() -> void:
	pass

func _process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if raycastright.is_colliding() and not player_detected:
		direction = -1
	if raycastleft.is_colliding() and not player_detected:
		direction = 1
		
	position.x += direction * SPEED * delta
	
	move_and_slide()
	
func _on_hurtbox_area_entered(area: Area2D) -> void:
	Global.kills += 1
	Global.score += 10
	queue_free()

func _on_jump_timeout() -> void:
	velocity.y += JUMP_VELOCITY


func _on_left_player_detector_body_entered(body: Node2D) -> void:
	player_detected = true
	direction = -1


func _on_right_player_detector_body_entered(body: Node2D) -> void:
	player_detected = true
	direction = 1


func _on_left_player_detector_body_exited(body: Node2D) -> void:
	player_detected = false


func _on_right_player_detector_body_exited(body: Node2D) -> void:
	player_detected = false
