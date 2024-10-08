extends AttachablePart
#variable "robot" can be used to refer to the player character

const JUMP_VELOCITY = -250.0
const SPEED = 100.0

var anim = "walk"

func activate():
	#In this case, jumping is handled in the physics process
	pass

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not robot.is_on_floor():
		robot.velocity += robot.gravity * delta
		if anim != "jump":
			$AnimatedSprite2D.play("jump", 1.0, false)
			anim = "jump"
	elif anim!= "walk":
		$AnimatedSprite2D.play("default", 1.0, false)
		anim = "walk"
	
	#Jump
	if Input.is_action_just_pressed("ui_accept") and robot.is_on_floor() and robot.can_control:
		if !robot.in_water: 
			robot.velocity.y = JUMP_VELOCITY 
		else: 
			robot.velocity.y = JUMP_VELOCITY/1.4

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
