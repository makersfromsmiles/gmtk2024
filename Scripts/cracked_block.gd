extends BaseBlock

func destroy():
	$CPUParticles2D.emitting = true
	$Sprite2D.visible = false
	await get_tree().create_timer(0.2).timeout
	queue_free()
