class_name Net2

extends Area2D

@onready var line_2d = $Line2D
@onready var collision_shape_2d = $CollisionShape2D

func _ready():
	line_2d.add_point(to_local(position))
	line_2d.add_point(to_local(position))
	var segment_shape = SegmentShape2D.new()
	segment_shape.a = to_local(position)
	segment_shape.b = to_local(position)
	collision_shape_2d.shape = segment_shape

func lengthenNet(currentPos: Vector2):
	line_2d.set_point_position(1, currentPos)
	collision_shape_2d.shape.b = currentPos
	
func _on_body_entered(body):
	if body is Fly2:  # Sprawdza, czy mucha dotknęła nici
		body.stuck()

func _on_body_exited(body):
	if body is Fly2:  # Sprawdza, czy mucha dotknęła nici
		body.notStuck()
