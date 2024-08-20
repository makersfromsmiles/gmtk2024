extends CharacterBody2D

const CLIMB_VELOCITY = -250.0

const KILL_DISTANCE_LIMIT = 79
var last_known_y = 0

var mid_jump = false;

var can_control = true
var previous_frame_y_velocity
var previous_frame_x_velocity

var knockback_velocity = Vector2(0,0)
const KNOCKBACK_RECOVERY_SPEED = 4

var can_jump = true

@onready var reset_timer = $Timer

const LEGS = ["res://Objects/LegParts/wheel_legs.tscn","res://Objects/LegParts/jump_legs.tscn","res://Objects/LegParts/spring_legs.tscn"]
const ARMS = ["res://Objects/Arm Parts/punch_arm.tscn","res://Objects/Arm Parts/shove_arm.tscn","res://Objects/Arm Parts/fin_arm.tscn"]
var current_arm = 0
var current_leg = 0

func _ready():
	current_arm = randi_range(0,len(ARMS)-1)
	current_leg = randi_range(0,len(LEGS)-1)
	
	equip_parts(current_arm,current_leg)
	
func _process(delta):
	#Check for fall damage
	if is_on_floor() && can_control:
		#print(position.y - last_known_y)
		if position.y - last_known_y > KILL_DISTANCE_LIMIT:
			$AnimationPlayer.play("robot_die", -1, 1.0, false)
			can_control = false
			reset_timer.start()
		else:
			last_known_y = position.y
	elif not is_on_floor() && can_control:
		if position.y < last_known_y: last_known_y = position.y
		
	#Self destruct button
	if Input.is_action_just_pressed("reset"):
		$AnimationPlayer.play("robot_die", -1, 1.0, false)
		can_control = false
		reset_timer.start()
	
func _can_jump():
	return is_on_floor() and can_control

func _can_climb():
	return is_on_floor() and is_on_wall() and can_control

func _can_move_midair():
	return velocity.y < 0 or mid_jump

func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()

func equip_parts(arm_index, leg_index):
	#Equip arms
	var arm_scene = load(ARMS[arm_index])
	var arm_instance = arm_scene.instantiate()
	$ArmPointL.add_child(arm_instance)
	arm_instance = arm_scene.instantiate()
	$ArmPointR.add_child(arm_instance)
	
	#Equip leg
	var leg_scene = load(LEGS[leg_index])
	var leg_instance = leg_scene.instantiate()
	$LegPoint.add_child(leg_instance)
	
	#Create collision bounds
	var shape = RectangleShape2D.new()
	var point_parts = [$HeadPoint.get_child(0, false), $LegPoint.get_child(0, false)]
	var min_bound = Vector2(0, 0)
	var max_bound = Vector2(0, 0)
	
	for part in point_parts:
		if not part is Area2D:
			continue
		var attachment_point_position = part.get_parent().position
		
		min_bound.x = min(min_bound.x, part.min_bound.x)+attachment_point_position.x
		min_bound.y = min(min_bound.y, part.min_bound.y)+attachment_point_position.y
		
		max_bound.x = max(max_bound.x, part.max_bound.x)+attachment_point_position.x
		max_bound.y = max(max_bound.y, part.max_bound.y)+attachment_point_position.y
	
	var size = max_bound - min_bound
	var center = min_bound + size / 2
	
	# Currently, this method causes the player to float if they have arms. Should they Tetris, instead?
	var collision_shape = get_node("CollisionShape2D")
	collision_shape.position = center
	shape.size = size
	
	collision_shape.set_shape(shape)

func calculate_xy(delta):
	#Scripts that should be run at the end of every leg movement script
	#velocity += knockback_velocity
	position += knockback_velocity
	knockback_velocity = Vector2(lerp(knockback_velocity.x, 0.0, delta*KNOCKBACK_RECOVERY_SPEED), lerp(knockback_velocity.y, 0.0, delta*KNOCKBACK_RECOVERY_SPEED))
	previous_frame_y_velocity = velocity.y
	previous_frame_x_velocity = velocity.x
