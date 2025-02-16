extends Area2D

enum State {
	STILL,
	RISING,
	LOWERING
}
@export var current_state = State.STILL
var speed = 2

func _ready():
	pass 

func _process(delta):
	match current_state:
		State.STILL:
			pass
		State.RISING:
			scale.y += delta * speed
			pass
		State.LOWERING:
			scale.y -= delta * speed
			pass
		_: 
			pass
	clamp(scale.y, 0, 1000)
		
	pass


func _on_body_entered(body):
	if body.is_in_group("player"):
		body.in_water = true
	pass # Replace with function body.


func _on_body_exited(body):
	if body.is_in_group("player"):
		body.in_water = false
	pass # Replace with function body.


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		current_state = State.RISING
	pass # Replace with function body.
