class_name Spider2

extends Area2D

@onready var animated_sprite_2d = $AnimatedSprite2D

signal netStartSignal
signal netUpdateSignal

const SPEED = 50.0
const ROTATION_SPEED = PI / 5
const MAX_DISTANCE = 500
const MIN_DISTANCE = 100
const WORLD_BOUNDRY = Vector2(3000,1500)

enum Action {
	CHOOSE_DIRECTION,
	START_MAKING_NET,
	FINISH_MAKING_NET,
	CHOOSE_DISTANCE,
	CALCULATE_TARGET_PLACE,
	TURN,
	MOVE_AND_CREATE_WEB,
	MOVE,
	FOLLOW,
	CALCULATE_DIRECTION,
	
}

var actionQueue = [
	Action.CHOOSE_DIRECTION,
	Action.TURN,
	Action.CHOOSE_DISTANCE,
	Action.CALCULATE_TARGET_PLACE,
	Action.MOVE,
	Action.CHOOSE_DIRECTION,
	Action.TURN,
	Action.CHOOSE_DISTANCE,
	Action.CALCULATE_TARGET_PLACE,
	Action.START_MAKING_NET,
	Action.MOVE_AND_CREATE_WEB,
	]
var followQueue = [
	Action.CALCULATE_DIRECTION,
	Action.TURN,
	Action.MOVE
]
var followMode = false
var currentState := 0
var targetPlace: Vector2
var direction: float
var distance: float
var currentNet: Net2 #public

func _ready():
	animated_sprite_2d.play("default")

func _physics_process(delta):
	var action: Action
	if (followMode): 
		action = followQueue[currentState]
	else: 
		action = actionQueue[currentState]
	
	match action:
		Action.CHOOSE_DIRECTION: chooseDirection()
		Action.CHOOSE_DISTANCE: chooseDistance()
		Action.CALCULATE_TARGET_PLACE: calculateTargetPlace()
		Action.TURN: turn(delta)
		Action.MOVE: move(delta)
		Action.START_MAKING_NET: startNet()
		Action.MOVE_AND_CREATE_WEB: moveAndWeave(delta)
		Action.CALCULATE_DIRECTION: calculateDirection()

func calculateDirection():
	direction = (targetPlace - position).normalized().angle()
	NextState()

func startNet():
	netStartSignal.emit(self)
	NextState()

func updateNet():
	netUpdateSignal.emit(self)

func moveAndWeave(delta):
	move(delta)
	updateNet()

func move(delta): 
	var motion = Vector2(SPEED, 0).rotated(direction) * delta
	position += motion
	if position.distance_to(targetPlace) < 5:
		NextState()

func calculateTargetPlace():
	targetPlace = position + Vector2(cos(direction), sin(direction)) * distance
	if(targetPlace.x < WORLD_BOUNDRY.x && targetPlace.x > 0 && targetPlace.y < WORLD_BOUNDRY.y && targetPlace.y > 0):
		NextState()
	else:
		currentState -= 3

func chooseDirection():
	direction = randf() * TAU
	NextState()

func chooseDistance():
	distance = MIN_DISTANCE + randf() * (MAX_DISTANCE - MIN_DISTANCE)
	NextState()

func turn(delta): 
	var angle_diff = direction - rotation
	angle_diff = wrapf(angle_diff, -PI, PI)
	rotation += ROTATION_SPEED * delta * sign(angle_diff)
	if abs(angle_diff) < 0.01:
		NextState()

func NextState():
	var queue: Array
	if (followMode):
		queue = followQueue
	else:
		queue = actionQueue
	
	currentState += 1
	if (currentState >= queue.size()): 
		currentState = 0
		followMode = false
