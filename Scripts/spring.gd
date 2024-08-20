extends Area2D
@onready var spring_sprite: AnimatedSprite2D = $SpringSprite

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Robot":
		(body as Robot).knockback_velocity.y = -10
		spring_sprite.stop()
		spring_sprite.play("Spring")
