class_name Fly2

extends CharacterBody2D

signal caught_in_net

@onready var arrow: Node2D = $Arrow
@onready var sprite_2d = $AnimatedSprite2D

const SPEED = 500.0
const ACCELERATION = 3000.0
const FRICTION = 1000.0
const GRAVITY = 1000.0

var isStuck: bool = false
var fruitPosition: Vector2

func _physics_process(delta):
	updateArrowDirection()
	var flyMultiplier = 1
	if (isStuck == true):
		flyMultiplier = 0.005
	var input_vector = Vector2.ZERO
	
	if Input.is_action_pressed("fly_up"):
		input_vector.y -= 1
	if Input.is_action_pressed("fly_down"):
		input_vector.y += 1
	if Input.is_action_pressed("fly_left"):
		input_vector.x -= 1
		sprite_2d.scale.x = -1
	if Input.is_action_pressed("fly_right"):
		input_vector.x += 1
		sprite_2d.scale.x = 1

	if input_vector.length() > 0:
		input_vector = input_vector.normalized()

	velocity = velocity.move_toward(input_vector * SPEED * flyMultiplier, ACCELERATION * delta * flyMultiplier)
	
	# Spowalnianie, jeśli nie ma żadnego wejścia (friction)
	if input_vector == Vector2.ZERO:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		velocity.y += GRAVITY * delta * flyMultiplier  # Dodaj grawitację

	# Poruszanie muchą
	move_and_slide()

func updateArrowDirection():
	arrow.rotation = (fruitPosition - position).normalized().angle()
	if (position.distance_to(fruitPosition) < 200):
		disableArrow()
	else:
		enableArrow()

func enableArrow():
	arrow.visible = true

func disableArrow():
	arrow.visible = false

func stuck():
	isStuck = true
	velocity = Vector2.ZERO  # Natychmiastowe zatrzymanie muchy
	caught_in_net.emit()

func notStuck(): 
	isStuck = false
