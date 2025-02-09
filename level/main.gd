extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.health = 5
	Global.kills = 0
	Global.score = 0

func _process(delta: float) -> void:
	update_scoreboard()
	if Global.health <= 0:
		game_over()
		
func game_over():
	get_tree().change_scene_to_file("res://end screen/EndScreen.tscn")
	
	

func _on_timer_timeout() -> void:
	Global.score += 1

func update_scoreboard() -> void:
	$CanvasLayer/UI/Scoreboard.text = "Score: %d" % Global.score
	$CanvasLayer/UI/Kills.text = "Kills: %d" % Global.kills
	$CanvasLayer/UI/Heart/Health.text = "%d" % Global.health
	
