extends Camera2D

"""
This node is also a game manager I decided.
"""

const level_position_offset : float = 1052
const move_speed : float = 500
const move_speed_lerp : float = 1

var level_num : int = 0

@export var puzzle_node : Node 
@export var win_menu : Control 

## Positions the player will respawn in.
## a checkpoint is reached every camera position change.
# I don't want to bother making this a tool rn.
@export var checkpoint_positions : Array[Vector2] = [Vector2(70, 440)]
@export var player : Player

@export var water : Area2D

func _ready() -> void:
	await get_tree().process_frame
	player.Died.connect(reset_level)

# Camera stuff
func _on_camera_trigger_body_entered(body: Node2D) -> void:
	if is_instance_of(body, Player):#body.get_script() is Player:
		level_num += 1
		pass

func _process(delta: float) -> void:
	global_position = global_position.slerp(Vector2(level_position_offset * level_num, global_position.y), move_speed_lerp * delta)
	
	# turning on the screen when we get there.
	if global_position.x > level_position_offset - 100 \
		and puzzle_node:
			puzzle_node.visible = true
			puzzle_node.get_parent().offset.x = level_position_offset - global_position.x


# Game manager stuff
func reset_level():
	player.global_position = checkpoint_positions[level_num]
	# TODO also reset the water level and reset the pipes?? (that sounds hard)
	water.scale.y = 1


func _on_game_won(body: Node2D) -> void:
	win_menu.visible = true
	pass # Replace with function body.
