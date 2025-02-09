extends Control

@onready var score_label: Label = $ScoreLabel
@onready var kills_label: Label = $KillsLabel
@onready var high_score_label: Label = $HighScoreLabel

func _ready() -> void:
	score_label.text = "SCORE: " + str(Global.score)
	kills_label.text = "KILLS: " + str(Global.kills)
	if Global.score > Global.highscore:
		Global.highscore = Global.score
	high_score_label.text = "HIGH SCORE: " + str(Global.highscore)
