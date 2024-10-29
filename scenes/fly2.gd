class_name Fly2

extends CharacterBody2D

signal caught_in_net

@onready var arrow: Node2D = $Arrow
@onready var sprite_2d = $AnimatedSprite2D
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

@onready var audio_stream_player_2: AudioStreamPlayer = $AudioStreamPlayer2


const SPEED = 500.0
const ACCELERATION = 3000.0
const FRICTION = 1000.0
const GRAVITY = 1000.0

var isStuck: bool = false
var fruitPosition: Vector2
var flying:= false

var input_vector = Vector2.ZERO
var move_up = false
var move_down = false
var move_left = false
var move_right = false

func _input(event):
	if event.is_action_pressed("fly_up"):
		move_up = true
	elif event.is_action_released("fly_up"):
		move_up = false
	if event.is_action_pressed("fly_down"):
		move_down = true
	elif event.is_action_released("fly_down"):
		move_down = false
	if event.is_action_pressed("fly_left"):
		move_left = true
		sprite_2d.scale.x = -1
	elif event.is_action_released("fly_left"):
		move_left = false
	if event.is_action_pressed("fly_right"):
		move_right = true
		sprite_2d.scale.x = 1
	elif event.is_action_released("fly_right"):
		move_right = false

func _physics_process(delta):
	input_vector = Vector2.ZERO
	if move_up:
		input_vector.y = -1
	elif move_down:
		input_vector.y = 1
	if move_left:
		input_vector.x = -1
	elif move_right:
		input_vector.x = 1
	var flyMultiplier = 1
	if (isStuck == true): 
		flyMultiplier = 0.005
	if input_vector.length() > 0:
		input_vector = input_vector.normalized()
		flying = true
	else:
		flying = false
	velocity = velocity.move_toward(input_vector * SPEED * flyMultiplier, ACCELERATION * delta * flyMultiplier)
	if input_vector == Vector2.ZERO:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		velocity.y += GRAVITY * delta * flyMultiplier
	move_and_slide()

func _process(_delta):
	updateArrowDirection()
	if flying:
		audio_stream_player.volume_db = -10
	else:
		audio_stream_player.volume_db = -20

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
	audio_stream_player_2.play()
	isStuck = true
	velocity = Vector2.ZERO
	caught_in_net.emit()

func notStuck(): 
	isStuck = false
