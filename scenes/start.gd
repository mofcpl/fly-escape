extends ReferenceRect

signal anyKeyPressed
signal readyScene

func _ready():
	readyScene.emit()

func _input(event):
	if event is InputEventKey and event.pressed:
		get_tree().change_scene_to_file("res://scenes/world.tscn")
