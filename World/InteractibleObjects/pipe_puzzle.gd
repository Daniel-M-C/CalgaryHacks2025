@tool
extends GridContainer
class_name PipePuzzle

signal PuzzleFinished

@export var start_pipe : PipeSection
@export var end_pipe : PipeSection

enum PIPE_COLOR {
	RED,
	GREEN,
	YELLOW
}

@export var active_color : PIPE_COLOR = PIPE_COLOR.RED:
	set(val):
		active_color = val
		


## Resets the filled water when changed
@export var reset_dummy : bool = false:
	set(val):
		reset_dummy = val
		for i in get_children():
			i.full = false

## Fills the start when changed
@export var fill_dummy : bool = false:
	set(val):
		fill_dummy = val
		if start_pipe:
			start_pipe.full = true

func _ready() -> void:
	end_pipe.IsFull.connect(finish_puzzle)
	pass

func finish_puzzle():
	PuzzleFinished.emit()

func reset_stuff():
	for i in get_children():
		if is_instance_of(i, PipeSection):
			i.PipeDirectionChanged.connect(re_flow_water)
			
			if i.starting_rotation != 0 :
				i.rotation = i.starting_rotation * PI/2
				pass
		# aaaaaa, hopefuly this fixes stuf 
		#i.pipe_type = i.pipe_type
		#i.starting_rotation = i.starting_rotation
	

func re_flow_water():
	## Resets and flows all pipes
	for i in get_children():
		if is_instance_of(i, PipeSection):
			i.full = false
	if start_pipe:
			start_pipe.full = true
	pass

func is_color_active(color : int):
	## color refs to pipe color.
	# could just check, but functions are nice.
	return color == active_color
	


func _on_visibility_changed() -> void:
	if is_inside_tree():
		await get_tree().process_frame
		if color.visible == false:
			color.visible = true
		elif color.visible == true:
			color.visible = false
		reset_stuff()
	pass # Replace with function body.
