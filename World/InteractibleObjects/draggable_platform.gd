extends StaticBody2D


# There might be a built in way to do this
var is_mouse_in_shape : bool = false
var has_drag_started : bool = false
var drag_start_position : Vector2 = Vector2.ZERO

func _ready() -> void:
	pass

func _mouse_enter() -> void:
	is_mouse_in_shape = true
	# TODO change cursor to drag
	
	pass
	
func _mouse_exit() -> void:
	is_mouse_in_shape = false
	has_drag_started = false
	pass
	
func _process(delta):
	
	# only want to do stuff if the mouse is in the shape.
	if is_mouse_in_shape:
		
		
		if Input.is_action_just_pressed("mouse_1" ):
			has_drag_started = true
			drag_start_position = get_global_mouse_position()
		
		if Input.is_action_pressed("mouse_1") and has_drag_started:
			global_position = drag_start_position - get_global_mouse_position()
			
		if Input.is_action_just_released("mouse_1"):
			has_drag_started = false
			
			
