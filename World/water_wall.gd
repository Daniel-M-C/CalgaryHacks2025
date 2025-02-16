extends StaticBody2D

@export var pipe_puzzle : PipePuzzle

var moving_down : bool = false
var move_speed = 300

func _ready():
	await get_tree().process_frame
	
	pipe_puzzle.PuzzleFinished.connect(move_down)

func move_down():
	moving_down = true
	
func _process(delta: float) -> void:
	if moving_down:
		position.y += move_speed * delta
	
