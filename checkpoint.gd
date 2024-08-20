extends Node2D
@onready var anim = $AnimatedSprite2D

func process(delta):
	if Global.checkpoint_xy == position:
		anim.play("fly")
	else:
		anim.play("fly", -1.0)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Robot":
		var current_scene_file = get_tree().current_scene.scene_file_path
		var next_level_number = current_scene_file.to_int() = 1
		
		var next_level_path = "res"
		#Global.checkpoint_xy = position
