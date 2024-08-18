extends CharacterBody2D


const SPEED = 80.0
const JUMP_VELOCITY = -200.0
const KILL_VELOCITY = 350

var can_control = true
var previous_frame_y_velocity

@onready var reset_timer = $Timer

func _ready():
	var shape = CollisionShape2D.new()
	#var legSprite = $LegPoint.$Legs.$Sprite2D
	#shape.size = Vector2(2 + legSprite.texture.get_width(),16 + legSprite.texture.get_height())
	shape.size = Vector2(24,24)
	$CollisionShape2D.set_shape(shape)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		if previous_frame_y_velocity > KILL_VELOCITY:
			can_control = false
			reset_timer.start()
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and can_control:
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	if can_control:
		var direction := Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	else:
		velocity.x = lerp(velocity.x, 0.0, delta*4)
	
	previous_frame_y_velocity = velocity.y
	move_and_slide()


func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
