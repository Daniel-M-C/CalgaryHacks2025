extends StaticBody2D
@export var start_cable : Node
@export var flow_puzzle : Node


func _ready():
	if start_cable:
		connect_plug(start_cable)

func connect_plug(cable):
	print(cable)
	$PinJoint2D.set_node_b(cable.get_path())
	
	pass
func disconnect_plug():
	$PinJoint2D.set_node_b("")
