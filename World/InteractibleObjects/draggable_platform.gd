@tool
extends StaticBody2D


# There might be a built in way to do this
var is_mouse_in_shape : bool = false
var has_drag_started : bool = false

@onready var self_start_position : Vector2 = global_position

var drag_start_position : Vector2 = Vector2.ZERO

# region markers
@onready var max_x_marker: Marker2D = $MaxX
@onready var min_x_marker: Marker2D = $MaxX
@onready var max_y_marker: Marker2D = $MaxY
@onready var min_y_marker: Marker2D = $MinY


const SERVER_A = preload("res://Assets/Environment/server_A.png")
const SERVER_B = preload("res://Assets/Environment/server_B.png")
const SERVER_C = preload("res://Assets/Environment/server_C.png")
const SERVER_D = preload("res://Assets/Environment/server_D.png")

@onready var sprite: Sprite2D = $Sprite
@onready var collision_shape_rect: Shape2D = $CollisionShape2D.shape

enum PLATFORM_TYPE {
	A,
	B,
	C,
	D
}

@export var platform_type : PLATFORM_TYPE = PLATFORM_TYPE.A :
	set(val):
		platform_type = val
		
		if not is_inside_tree():
			await tree_entered
			await get_tree().process_frame
		match platform_type:
			PLATFORM_TYPE.A:
				sprite.texture = SERVER_A
				sprite.scale.x = 2.2
				collision_shape_rect.size = Vector2(102,165)
			PLATFORM_TYPE.B:
				sprite.texture = SERVER_B
				sprite.scale.x = 2.2
				collision_shape_rect.size = Vector2(102,165)
			PLATFORM_TYPE.C:
				sprite.texture = SERVER_C
				sprite.scale.x = 2.2
				collision_shape_rect.size = Vector2(102,165)
			PLATFORM_TYPE.D:
				sprite.texture = SERVER_D
				sprite.scale.x = 2.2
				collision_shape_rect.size = Vector2(102,165)

# endregion

## The speed at which the platform should retun to it's original position
## When the player lets go of it.
@export var return_speed : float = 200

## The max speed at which the platform can move when it's being dragged.
@export var move_speed : float = 500

@export var lock_x : bool = false
@export var lock_y : bool = false


## Movement in x will be capped at this value.
@export var max_x : float = 0:
	set(val):
		max_x = val
		if max_x_marker:
			max_x_marker.position.x = val
## Movement in x will be capped at this value.
@export var min_x : float = 0:
	set(val):
		min_x = val
		if min_x_marker:
			min_x_marker.position.x = val

## Movement in y will be capped at this value.
@export var max_y : float = 0:
	set(val):
		max_y = val
		if max_y_marker:
			max_y_marker.position.y = val
## Movement in y will be capped at this value.
@export var min_y : float = 0:
	set(val):
		min_y = val
		if min_y_marker:
			min_y_marker.position.y = val

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
	if not Engine.is_editor_hint():
		
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
													get_global_mouse_position().clamp(
																				# This is an offset, so it has to be clamped 
																				# to the offset from the start pos
																				self_start_position + Vector2(min_x,min_y),
																				self_start_position + Vector2(max_x,max_y) ), 
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
