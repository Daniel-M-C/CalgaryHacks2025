extends Node

var player
var not_in_water_setup = true
# Called when the node enters the scene tree for the first time.
func _ready():
	get_player()

func _process(delta):
	if player:
		if player.in_water and not_in_water_setup:
			var time = $WorldMusic.get_playback_position()
			$WaterMusic.play(time)
			$WorldMusic.stop()
			not_in_water_setup = false
		if !player.in_water and !not_in_water_setup:
			var time = $WaterMusic.get_playback_position()
			$WorldMusic.play(time)
			$WaterMusic.stop()
			not_in_water_setup = true
			

func _input(event):
	if event.is_action_pressed("mouse_1"):
		$MousePressSound.play()
	if event.is_action_released("mouse_1"):
		$MouseReleaseSound.play()

func _on_audio_stream_player_finished():
	$WorldMusic.play()
	pass # Replace with function body.

func get_player():
	if get_tree().get_first_node_in_group("player"):
		player = get_tree().get_first_node_in_group("player")
	else: 
		await get_tree().process_frame
		get_player()
