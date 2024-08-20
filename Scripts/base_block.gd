extends RigidBody2D

class_name BaseBlock

const FALL_SPEED = 100
var velocity = Vector2(0,0)

func _process(delta: float) -> void:
	angular_velocity = 0
	gravity_scale = 0
	
	var raycast1 = $FallRay1
	var raycast2 = $FallRay2
	if not raycast1.is_colliding() && not raycast2.is_colliding():
		position.y += FALL_SPEED*delta
		
	if not fmod(position.x, 16) == 0:
		position.x = lerp(position.x, round(position.x/16)*16, delta*50)

func Shove(force: int):
	var raycast1 = $ShoveRay1
	var raycast2 = $ShoveRay2
	raycast1.scale.x = force/abs(force)
	raycast2.scale.x = force/abs(force)
	
	if not raycast1.is_colliding() && not raycast2.is_colliding():
		position.x += force
