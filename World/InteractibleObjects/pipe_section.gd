@tool
extends Button
class_name PipeSection

signal IsFull
signal PipeDirectionChanged
# region color
@onready var color_indicator: TextureRect = $ColorIndicator

enum PIPE_COLOR {
	RED,
	GREEN,
	YELLOW
}

@export var color : PIPE_COLOR = PIPE_COLOR.RED:
	set(val):
		color = val
		if not is_inside_tree():
			await tree_entered
			await get_tree().process_frame
		
		match color:
			PIPE_COLOR.RED :
				color_indicator.self_modulate = Color.RED
			PIPE_COLOR.GREEN :
				color_indicator.self_modulate = Color.GREEN
			PIPE_COLOR.YELLOW :
				color_indicator.self_modulate = Color.YELLOW

# end region 

## As up right down left
@export var default_used_ports : Array[bool] = [false, false, false, false]
@export var true_used_prots : Array[bool] = default_used_ports

enum PIPE_TYPE {
	ONE,
	TWO_TOGETHER,
	TWO_STRAGIHT,
	T,
	X
}

var ONE_texture = preload("res://Assets/Environment/pipe_one.png")
var TWO_TOGETHER_texture = preload("res://Assets/Environment/pipe_two_together.png")
var TWO_STRAGIHT_texture = preload("res://Assets/Environment/pipe_two_straight.png")
var T_texture = preload("res://Assets/Environment/pipe_t.png")
var X_texture = preload("res://Assets/Environment/pipe_x.png")


@export var pipe_type : PIPE_TYPE:
	set(val):
		pipe_type = val
		match pipe_type:
			PIPE_TYPE.ONE:
				icon = ONE_texture
				default_used_ports = [true,false,false,false]
			PIPE_TYPE.TWO_TOGETHER:
				icon = TWO_TOGETHER_texture
				default_used_ports = [true,true,false,false]
			PIPE_TYPE.TWO_STRAGIHT:
				icon = TWO_STRAGIHT_texture
				default_used_ports = [true,false,true,false]
			PIPE_TYPE.T:
				icon = T_texture
				default_used_ports = [true,true,false,true]
			PIPE_TYPE.X:
				icon = X_texture
				default_used_ports = [true,true,true,true]
				
		true_used_prots = default_used_ports

#@onready var texture_rect: TextureRect = $CenterContainer/TextureRect
var texture : Texture2D :
	set(val):
		texture = val
		texture = val

## goes up two four
@export var starting_rotation : int = 0:
	set(val):
		if val > 3:
			val = 0
		if val < 0:
			val = 3
		starting_rotation = val
		if not is_inside_tree():
			await tree_entered
			await get_tree().process_frame
			
		# reset so things aren't weird
		rotation = 0
		true_used_prots = default_used_ports 
		
		for i in range(val):
			rotate_once()

@onready var full_indicator: TextureRect = $FullIndicator

## Done as an int so that it counts how many are filling it
## Filling is done in reverse 
## aaa nvm
@export var full : bool = false:
	set(val):
		full = val
		if not is_inside_tree():
			await tree_entered
			await get_tree().process_frame
		# fills the rest in a cascade
		if full :
			for i in range(4):
				if true_used_prots[i]:
					if get_neighbour(i) and not get_neighbour(i).full:
						# check that it's receiving there.
						if get_neighbour(i).true_used_prots[(i + 2) % 4]:
							get_neighbour(i).full = true
		
			await get_tree().process_frame
			full_indicator.visible = full
			IsFull.emit()

func _ready():
	# runs the setter
	#starting_rotation = starting_rotation
	pass

#Only expands horizontally, then it is made square here. #Can't fill vertically, because that would squish them all into the screen and remove scroll functionality. #AspectRatioContainer didn't work because the button just overflows the Continer. 
func _on_resized():
	custom_minimum_size.y = size.x
	pivot_offset = size/2 

func _on_pressed() -> void:
	if get_parent().is_color_active(color):
		rotate_once()
	PipeDirectionChanged.emit()
	
func rotate_once() :
	
	# just rotates the values clockwise.
	# addmitedly not the prettiest way of doing this.
	var temp_port : bool = true_used_prots[3]
	for i in 3:
		true_used_prots[3 - i] = true_used_prots[2 - i]
	
	true_used_prots[0] = temp_port
	rotation += PI/2
	pass

func get_neighbour(direction : int) -> Control:
	"""
	:param: direction as up, right, down, left
	"""
	
	var self_index = int(name.trim_prefix("PipeSection")) - 1
	var looking_index = 0
	if looking_index == 4:
		pass
	match direction:
		0:
			looking_index = self_index - 7
		1:
			looking_index = self_index + 1
		2:
			looking_index = self_index + 7
		3:
			looking_index = self_index - 1
	
	if looking_index < 30 and looking_index > 0:
		return get_parent().get_child(looking_index)
	else:
		return null

func fill_with_water() -> void:
	## Not used ?
	full = true
	
	for i in range(4):
		if true_used_prots[i]:
			if get_neighbour(i):
				get_neighbour(i).full = true
