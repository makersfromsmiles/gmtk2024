extends RigidBody2D

class_name BaseBlock

const FALL_SPEED = 200


func _process(delta: float) -> void:
	linear_velocity.y = 200 * delta
	linear_velocity.x = move_toward(linear_velocity.x, 0, 200*delta)
	angular_velocity = 0

func Shove(force: int):
	linear_velocity.x = force
