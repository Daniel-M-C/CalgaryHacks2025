@tool
extends GridContainer

@export var start_pipe : Button
@export var end_pipe : Button

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
	#for i in get_children():
		# re-runs setter because it wasn't working
		#i.starting_rotation = i.starting_rotation
	pass
	
func is_color_active(color : int):
	## color refs to pipe color.
	# could just check, but functions are nice.
	return color == active_color
	
