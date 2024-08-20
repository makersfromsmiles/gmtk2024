extends AttachablePart

#Water physics
func _physics_process(delta):
	if get_overlapping_bodies() == []:
		robot.gravity = robot.get_gravity()
		robot.in_water = false
	else:
		if !robot.in_water && robot.velocity.y < 0: robot.velocity.y = robot.velocity.y * robot.WATER_GRAVITY_SCALE
		robot.gravity = robot.get_gravity()*robot.WATER_GRAVITY_SCALE
		robot.in_water = true
