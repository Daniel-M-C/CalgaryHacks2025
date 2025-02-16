extends StaticBody2D
#@export var start_cable : Node
@export var flow_puzzle : Node
enum COLOUR {
	RED,
	GREEN,
	YELLOW
}

@export var colour : COLOUR = COLOUR.RED:
	set(val):
		colour = val


func _ready():
	##if start_cable:
	##	connect_plug(start_cable)
	pass

func connect_plug(cable):
	print(cable)
	$PinJoint2D.set_node_b(cable.get_path())
	match colour:
		COLOUR.RED:
			flow_puzzle.active_color = flow_puzzle.PIPE_COLOR.RED
		COLOUR.GREEN:
			flow_puzzle.active_color = flow_puzzle.PIPE_COLOR.GREEN
		COLOUR.YELLOW:
			flow_puzzle.active_color = flow_puzzle.PIPE_COLOR.YELLOW
	
	pass
func disconnect_plug():
	$PinJoint2D.set_node_b("")
	flow_puzzle.active_color = -1
