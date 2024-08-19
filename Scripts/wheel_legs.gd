extends AttachablePart
#variable "robot" can be used to refer to the player character

const SPEED = 200.0

func activate():
	#In this case, jumping is handled in the physics process
	pass

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not robot.is_on_floor():
		robot.velocity += robot.get_gravity() * delta
		

	# Get the input direction and handle the movement/deceleration.
	if robot.can_control:
		var direction := Input.get_axis("ui_left", "ui_right")
		if direction:
			robot.velocity.x = direction * SPEED
		else:
			robot.velocity.x = move_toward(robot.velocity.x, 0, SPEED)
	elif not robot.is_on_floor() and not robot._can_move_midair():
		robot.velocity.x = 0.0
	else:
		robot.velocity.x = lerp(robot.velocity.x, 0.0, delta*4)
		
	robot.calculate_xy(delta)
	robot.move_and_slide()
