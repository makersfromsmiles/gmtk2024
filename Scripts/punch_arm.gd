extends AttachablePart

const KNOCKBACK_STRENGTH = 160

var block
var touching_wall = false

func activate():
	if robot.can_control:
		$AnimatedSprite2D.play("default", 1.0, false)
		#Destroy blocks
		if block: 
			match block.name:
				"Cracked Block":
					block.queue_free()
		
		#Bounce off walls
		if touching_wall:
			if get_parent().name == "ArmPointL":
				robot.knockback_velocity.x = KNOCKBACK_STRENGTH
			else:
				robot.knockback_velocity.x = KNOCKBACK_STRENGTH*-1

func _on_body_entered(body: Node2D) -> void:
	if body.name.contains("Block"):
		block = body
		
	if body is TileMapLayer: touching_wall = true


func _on_body_exited(body: Node2D) -> void:
	if body == block: block = null
	if body is TileMapLayer: touching_wall = false
