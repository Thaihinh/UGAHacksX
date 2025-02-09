extends Control

@onready var score_label: Label = $ScoreLabel
@onready var kills_label: Label = $KillsLabel

func _ready() -> void:
	score_label.text = "SCORE: " + str(Global.score)
	kills_label.text = "KILLS: " + str(Global.kills)
