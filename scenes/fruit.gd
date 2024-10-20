extends Area2D

class_name Fruit

signal harvested(fruit_instance: Fruit)

func _on_body_entered(body: Node2D) -> void:
	harvested.emit(self)
