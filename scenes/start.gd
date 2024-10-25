extends ReferenceRect

signal readyScene

func _ready() -> void:
	readyScene.emit()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		get_tree().change_scene_to_file("res://scenes/world.tscn")
