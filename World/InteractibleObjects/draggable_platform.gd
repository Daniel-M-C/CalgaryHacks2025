extends StaticBody2D


# There might be a built in way to do this
var is_mouse_in_shape : bool = false
var has_drag_started : bool = false

@onready var self_start_position : Vector2 = global_position

var drag_start_position : Vector2 = Vector2.ZERO

@export var lock_x : bool = false
@export var lock_y : bool = false

## The speed at which the platform should retun to it's original position
## When the player lets go of it.
@export var return_speed : float = 200

## The max speed at which the platform can move when it's being dragged.
@export var move_speed : float = 500

func _ready() -> void:
	pass

func _mouse_enter() -> void:
	is_mouse_in_shape = true
	# TODO change cursor to drag
	
	pass
	
func _mouse_exit() -> void:
	is_mouse_in_shape = false
	pass
	
func _process(delta):
	
	# only want to do stuff if the mouse is in the shape.
	if is_mouse_in_shape or has_drag_started:
		
		
		if Input.is_action_just_pressed("mouse_1" ):
			has_drag_started = true
			drag_start_position = get_global_mouse_position()

		
		if Input.is_action_pressed("mouse_1") and has_drag_started:
			# use ? depends on if we want a reset.
			# self_start_position - (drag_start_position - get_global_mouse_position())
			
			# this cancels out, but it might be useful later if we want to slow the
			# platforms down or smth, we can do a multiplier on the position??
			global_position = global_position.move_toward(  
												drag_start_position - (drag_start_position - get_global_mouse_position()),
												move_speed * delta)
			
			if lock_x:
				global_position.x = self_start_position.x
			
			if lock_y:
				global_position.y = self_start_position.y
		if Input.is_action_just_released("mouse_1"):
			has_drag_started = false
			
	if not has_drag_started:
		global_position = global_position.move_toward(self_start_position, delta * return_speed)
		pass
