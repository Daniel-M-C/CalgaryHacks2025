extends StaticBody2D
@export var activated = false
@export var start_cable : Node

func _ready():
	if start_cable:
		connect_plug(start_cable)

func connect_plug(cable):
	print(cable)
	$PinJoint2D.set_node_b(cable.get_path())
	activated = true
	
	pass
func disconnect_plug():
	$PinJoint2D.set_node_b("")
	activated = false
