extends Area2D

class_name AttachablePart

var collision_shape
var parent

var shape
var min_bound
var max_bound

@onready var robot: CharacterBody2D = $"../.."

func _ready():
	parent = get_parent().name
	collision_shape = get_node("CollisionShape2D")
	if collision_shape == null:
		return
	
	shape = collision_shape.shape
	if shape == null:
		return
		
	min_bound = get_parent().position - shape.size / 2
	max_bound = get_parent().position + shape.size / 2
	

func _physics_process(delta):
	if check_interact(): activate()

func check_interact():
	var pressed = false
	match parent:
		"ArmPointL":
			if Input.is_action_just_pressed("mouse_1"): pressed = true
		"ArmPointR":
			if Input.is_action_just_pressed("mouse_2"): pressed = true
		"LegPoint":
			if Input.is_action_just_pressed("ui_accept"): pressed = true
	return pressed

func activate():
	print("!")
