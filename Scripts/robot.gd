extends CharacterBody2D

const SPEED = 80.0
const JUMP_VELOCITY = -200.0
const KILL_VELOCITY_LIMIT = 380
const CLIMB_VELOCITY = -250.0

var mid_jump = false;

var can_control = true
var previous_frame_y_velocity

var can_jump = true

@onready var reset_timer = $Timer

func _ready():
	_create_collision_bounds()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		if previous_frame_y_velocity > KILL_VELOCITY_LIMIT:
			can_control = false
			reset_timer.start()
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and _can_climb():
		velocity.y = CLIMB_VELOCITY
		mid_jump = true
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and can_control:
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	if can_control:
		var direction := Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	elif not is_on_floor() and not _can_move_midair():
		velocity.x = 0.0
	else:
		velocity.x = lerp(velocity.x, 0.0, delta*4)
		
	previous_frame_y_velocity = velocity.y
	move_and_slide()
	
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
	
	var attachment_points = find_children("*", "AttachmentPoint", true)
	
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
