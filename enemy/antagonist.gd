extends Node2D

const speed = 60

var direction = 1

@onready var raycastright: RayCast2D = $raycastright
@onready var raycastleft: RayCast2D = $raycastleft

func _process(delta):
	if raycastright.is_colliding():
		direction = -1
		
	if raycastleft.is_colliding():
		direction = 1
		
	position.x += direction * speed * delta
	
