extends Area2D

class_name Fruit

const BANAN = preload("res://assets/graphics/banan.png")
const MALINA = preload("res://assets/graphics/malina.png")
const POMARANCZA = preload("res://assets/graphics/pomarancza.png")

@onready var sprite_2d: Sprite2D = $Sprite2D

var fruits := [BANAN, MALINA, POMARANCZA]

signal harvested(fruit_instance: Fruit)

func _ready():
	sprite_2d.texture = fruits[randi() % 3]

func _on_body_entered(body: Node2D) -> void:
	harvested.emit(self)
