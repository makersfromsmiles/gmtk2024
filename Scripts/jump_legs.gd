extends AttachablePart
@onready var robot: CharacterBody2D = $"../.."

func activate():
	if Input.is_action_just_pressed("ui_accept") and robot.is_on_floor() and robot.can_control:
		robot.velocity.y = robot.JUMP_VELOCITY
