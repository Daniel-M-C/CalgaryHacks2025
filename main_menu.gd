extends Control

const MAIN_WORLD = preload("res://World/main_world.tscn")

func _on_start_pressed():
	get_tree().change_scene_to_packed(MAIN_WORLD)

func _on_quit_pressed():
	$MarginContainer/VBoxContainer/HBoxContainer2.set_process(true)
	$MarginContainer/VBoxContainer/HBoxContainer2.visible = true

func _on_nevermind_pressed():
	$MarginContainer/VBoxContainer/HBoxContainer2.set_process(false)
	$MarginContainer/VBoxContainer/HBoxContainer2.visible = false
	
func _on_leave_pressed():
	get_tree().quit()
	
