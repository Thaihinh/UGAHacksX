extends Marker2D

var enemy: PackedScene = preload("res://enemy/slime.tscn")

func _on_respawn_timeout() -> void:
	var spawned_enemy = enemy.instantiate()
	owner.add_child(spawned_enemy)
	spawned_enemy.transform = global_transform


func _on_difficulty_1_timeout() -> void:
	print_debug("Difficulty increased (1)")
	$Respawn.wait_time = 5


func _on_difficulty_2_timeout() -> void:
	print_debug("Difficulty increased (2)")
	$Respawn.wait_time = 2
