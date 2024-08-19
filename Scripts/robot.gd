extends CharacterBody2D

const CLIMB_VELOCITY = -250.0

const KILL_DISTANCE_LIMIT = 79
var last_known_y = 0

var mid_jump = false;

var can_control = true
var previous_frame_y_velocity
var previous_frame_x_velocity

var can_jump = true

@onready var reset_timer = $Timer

func _ready():
	_create_collision_bounds()
	
func _process(delta):
	#Check for fall damage
	if is_on_floor() && can_control:
		#print(position.y - last_known_y)
		if position.y - last_known_y > KILL_DISTANCE_LIMIT:
			can_control = false
			reset_timer.start()
		else:
			last_known_y = position.y
	elif not is_on_floor() && can_control:
		if position.y < last_known_y: last_known_y = position.y
		#Comment this last elif to make fall damage not include jumps
	
func _can_jump():
	return is_on_floor() and can_control

func _can_climb():
	return is_on_floor() and is_on_wall() and can_control

func _can_move_midair():
	return velocity.y < 0 or mid_jump

func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()

func _create_collision_bounds():
	var shape = RectangleShape2D.new()
	
	#var attachment_points = find_children("*", "AttachmentPoint", true)
	var attachment_points = [$HeadPoint, $LegPoint]
	
	var min_bound = Vector2(0, 0)
	var max_bound = Vector2(0, 0)
	
	for point in attachment_points:
		if not point.has_collision:
			continue
			
		min_bound.x = min(min_bound.x, point.min_bound.x)
		min_bound.y = min(min_bound.y, point.min_bound.y)
		
		max_bound.x = max(max_bound.x, point.max_bound.x)
		max_bound.y = max(max_bound.y, point.max_bound.y)
	
	var size = max_bound - min_bound
	var center = min_bound + size / 2
	
	# Currently, this method causes the player to float if they have arms. Should they Tetris, instead?
	var collision_shape = get_node("CollisionShape2D")
	collision_shape.position = center
	shape.size = size
	
	collision_shape.set_shape(shape)
