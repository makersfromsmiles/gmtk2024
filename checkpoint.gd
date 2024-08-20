extends Node2D
@onready var anim = $AnimatedSprite2D

func process(delta):
	if Global.checkpoint_xy == position:
		anim.play("fly")
	else:
		anim.play("fly", -1.0)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Robot":
		pass
		#Global.checkpoint_xy = position
