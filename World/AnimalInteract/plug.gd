extends StaticBody2D

func _ready():
	pass 
	
func _process(delta):
	pass

func connect_plug(cable):
	print(cable)
	$PinJoint2D.set_node_b(cable.get_path())
	pass
func disconnect_plug():
	$PinJoint2D.set_node_b("")
