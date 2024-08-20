extends AttachablePart
#variable "robot" can be used to refer to the player character

const JUMP_VELOCITY = -360.0
const BOUNCE_VELOCITY = -200.0
const SPEED = 90
const JUMP_SPEED = 150
var current_speed = 90.0

var anim_frame = 0

func activate():
	pass

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not robot.is_on_floor():
		robot.velocity += robot.gravity * delta
	else:
		#Bounce higher and increase speed if space is held down
		if Input.is_action_pressed("ui_accept") and robot.is_on_floor() and robot.can_control:
			current_speed = JUMP_SPEED
			robot.velocity.y = JUMP_VELOCITY
		elif robot.can_control:
			current_speed = SPEED
			robot.velocity.y = BOUNCE_VELOCITY
		else:
			current_speed = SPEED
	

	# Get the input direction and handle the movement/deceleration.
	if robot.can_control:
		if current_speed != JUMP_SPEED or robot.is_on_floor():
			var direction := Input.get_axis("ui_left", "ui_right")
			if direction:
				robot.velocity.x = direction * current_speed
			else:
				robot.velocity.x = 0
	else:
		robot.velocity.x = lerp(robot.velocity.x, 0.0, delta*4)
	
	if robot.is_on_wall() && not robot.is_on_floor(): robot.velocity.x = robot.previous_frame_x_velocity
	
	#Animation
	if robot.is_on_floor():
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.play("default", 1.0, false)
	
	robot.calculate_xy(delta)
	robot.move_and_slide()
