extends Area2D

var speed: float = 175
var rng = RandomNumberGenerator.new()
var flip = false
var spin: float

func _ready() -> void:
	if rng.randf() > 0.5:
		$Sprite.scale.x *= -1
	if rng.randf() > 0.5:
		spin = 1
	else:
		spin = -1
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta
	$Sprite.rotation += spin * delta


func _on_body_entered(body: Node2D) -> void:
	queue_free()
