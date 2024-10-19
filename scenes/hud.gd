extends ReferenceRect

@onready var score_label = $ScoreLabel

func updateScore(score: int):
	score_label.text = "Score: "+ str(score)
