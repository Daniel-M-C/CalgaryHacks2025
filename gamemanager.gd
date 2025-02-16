extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("mouse_1"):
		$MousePressSound.play()
	if event.is_action_released("mouse_1"):
		$MouseReleaseSound.play()

func _on_audio_stream_player_finished():
	$WorldMusic.play()
	pass # Replace with function body.
