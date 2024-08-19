extends Node2D

class_name AttachmentPoint 

var current_part
var has_collision

var min_bound
var max_bound


func _ready():
	has_collision = false
	
	#TODO: Allow the changing of parts, recalculating bounds as a result. Event based callbacks?
	_calculate_bounds()

func _calculate_bounds():
	var attached_parts = find_children("*", "AttachablePart", false)
	
	if len(attached_parts) < 1:
		return
	
	current_part = attached_parts[0]
	if current_part.shape == null:
		return
	
	has_collision = true
	min_bound = position + current_part.min_bound
	max_bound = position + current_part.max_bound
