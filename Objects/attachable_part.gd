extends Area2D

class_name AttachablePart

var collision_shape

var shape
var min_bound
var max_bound

func _ready():
	collision_shape = get_node("CollisionShape2D")
	if collision_shape == null:
		return
	
	shape = collision_shape.shape
	if shape == null:
		return
		
	min_bound = position - shape.size / 2
	max_bound = position + shape.size / 2

func _process(delta):
	pass
