extends Camera2D

const level_position_offset : float = 1152
const move_speed : float = 500
const move_speed_lerp : float = 1

var level_num : int = 0

@export var puzzle_canvas_layer : Node 

func _on_camera_trigger_body_entered(body: Node2D) -> void:
	if is_instance_of(body, Player):#body.get_script() is Player:
		level_num += 1
		pass

func _process(delta: float) -> void:
	global_position = global_position.lerp(Vector2(level_position_offset * level_num, global_position.y), move_speed_lerp * delta)
	
	# turning on the screen when we get there.
	if global_position.x > level_position_offset - 100 \
		and puzzle_canvas_layer:
			puzzle_canvas_layer.visible = true
