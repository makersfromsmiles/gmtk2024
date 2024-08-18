extends CharacterBody2D

const SPEED = 80.0
const JUMP_VELOCITY = -200.0
const CLIMB_VELOCITY = -250.0
const KILL_VELOCITY = 350

var mid_jump = false;

var can_control = true
var previous_frame_y_velocity

var can_jump = true

@onready var reset_timer = $Timer

func _ready():
	var shape = RectangleShape2D.new()
	#var legSprite = $LegPoint.$Legs.$Sprite2D
	#shape.size = Vector2(2 + legSprite.texture.get_width(),16 + legSprite.texture.get_height())
	shape.size = Vector2(24,24)
	get_node("CollisionShape2D").set_shape(shape)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		if previous_frame_y_velocity > KILL_VELOCITY:
			can_control = false
			reset_timer.start()
	
	if is_on_floor():
		mid_jump = false;
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and _can_climb():
		velocity.y = CLIMB_VELOCITY
		mid_jump = true
	elif Input.is_action_just_pressed("ui_accept") and _can_jump():
		velocity.y = JUMP_VELOCITY
		mid_jump = true
	
	# Get the input direction and handle the movement/deceleration.
	if can_control and (is_on_floor() or _can_move_midair()):
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
