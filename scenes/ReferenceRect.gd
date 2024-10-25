extends ReferenceRect

@onready var label_3 = $Label3

@onready var label_2 = $Label2

var canSkip: bool = false

func _ready():
	setScore(Global.score)

func setScore(score: int):
	label_2.text = "You collected "+ str(score) + " points"


func _on_timer_timeout():
	canSkip = true
	label_3.text = "press any key"


func _input(event):
	if (event) is InputEventKey and event.pressed:
		if (canSkip): get_tree().change_scene_to_file("res://scenes/start.tscn")
