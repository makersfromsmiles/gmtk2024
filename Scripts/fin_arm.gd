extends AttachablePart

var in_water_count = 0

const Y_MOMENTUM = -6
const X_MOMENTUM = 2

func activate():
	$AnimationPlayer.play("fin flip", -1, 1.0, false)
	if robot.can_control and in_water_count > 0:
		robot.velocity.y = robot.velocity.y/2
		robot.knockback_velocity.y = Y_MOMENTUM
		if get_parent().name == "ArmPointL":
			robot.knockback_velocity.x = X_MOMENTUM
		else:
			robot.knockback_velocity.x = -X_MOMENTUM

func _on_body_entered(body: Node2D) -> void:
	in_water_count = in_water_count + 1


func _on_body_exited(body: Node2D) -> void:
	in_water_count = in_water_count - 1
	if in_water_count < 0:
		in_water_count = 0
