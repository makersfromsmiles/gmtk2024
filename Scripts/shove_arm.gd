extends AttachablePart

var block

const SHOVE_STRENGTH = 200

func activate():
	if robot.can_control:
		if block:
			if get_parent().name == "ArmPointL":
				(block as BaseBlock).Shove(-1 * SHOVE_STRENGTH)
			else:
				(block as BaseBlock).Shove(SHOVE_STRENGTH)
		

func _on_body_entered(body: Node2D) -> void:
	if body.name.contains("Block"):
		block = body


func _on_body_exited(body: Node2D) -> void:
	if body == block: block = null
