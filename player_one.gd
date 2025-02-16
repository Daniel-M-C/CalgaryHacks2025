extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const MAX_HP = 100
var hp = MAX_HP
var carry_objext = ""


func _physics_process(delta):
	
	if carry_objext:
		if global_position.x - carry_objext.global_position.x > 25 or global_position.y - carry_objext.global_position.y > 25:
			$GrabPoint.set_node_b("")
			carry_objext = ""
	
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		if velocity.x < 0:
			$AnimatedSprite2D.scale.x = -0.25
		elif velocity.x > 0:
			$AnimatedSprite2D.scale.x = 0.25
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _on_hurt_box_body_entered(body):
	if (body.damage):
		hp -= body.damge
	else:
		hp -= 10
		
	pass 
func _input(event):
	if event.is_action_pressed("action"):
		if $CarryArea.get_overlapping_bodies():
			carry_objext = $CarryArea.get_overlapping_bodies()[0]
			$GrabPoint.set_node_b(carry_objext.get_path())
			
			pass
		pass
	pass
