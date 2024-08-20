extends AttachablePart
#variable "robot" can be used to refer to the player character

const SPEED = 200.0
@onready var water_check: Marker2D = $Marker2D

var in_water_amount = 0

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
		
	
	
	if robot.is_on_floor() and robot.velocity.x != 0 and in_water_amount == 0:
		robot.set_collision_mask_value(4, true)
	else:
		robot.set_collision_mask_value(4, false)
	
	
	
	robot.calculate_xy(delta)
	robot.move_and_slide()




func _on_water_checker_body_entered(body: Node2D) -> void:
	in_water_amount = in_water_amount + 1


func _on_water_checker_body_exited(body: Node2D) -> void:
	in_water_amount = in_water_amount - 1
	if in_water_amount < 0:
		in_water_amount = 0
