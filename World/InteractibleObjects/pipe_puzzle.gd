@tool
extends GridContainer
class_name PipePuzzle

## Emmited when the puzzle is finished
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
	#for i in get_children():
		# re-runs setter because it wasn't working
		#i.starting_rotation = i.starting_rotation
	if end_pipe:
		end_pipe.IsFull.connect(finish_puzzle)
	pass
	
func is_color_active(color : int):
	## color refs to pipe color.
	# could just check, but functions are nice.
	return color == active_color
	
	
func finish_puzzle():
	# Should somehow show that things are done
	modulate = Color.hex(0xffffffaa)
	PuzzleFinished.emit()
	# disable moving of pipes
	active_color = -1
