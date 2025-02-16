extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const MAX_HP = 100
var hp = MAX_HP
var carry_objext = ""

func _physics_process(delta):
	
	if carry_objext:
		if global_position.x - carry_objext.global_position.x > 50 or global_position.y - carry_objext.global_position.y > 50:
			$GrabPoint.set_node_b("")
			carry_objext = ""
	
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		if velocity.y < 0:
			pass # play jump up
		if velocity.y > 0:
			pass # play jump down

	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$Audio/JumpSound.play()
		pass # play jump start
	
	var direction = Input.get_axis("left", "right")
	if direction:
		if velocity.y == 0:
			pass # play walking
		velocity.x = direction * SPEED
		if velocity.x < 0:
			$Sprite/AnimatedSprite2D.scale.x = -0.25
		elif velocity.x > 0:
			$Sprite/AnimatedSprite2D.scale.x = 0.25
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
		if carry_objext:
			if $InteractArea.get_overlapping_bodies():
				var action_object = $InteractArea.get_overlapping_bodies()[0]
				interact(action_object)
			$GrabPoint.set_node_b("")
			carry_objext = ""
			
				
		else:
			if $InteractArea.get_overlapping_bodies():
				var action_object = $InteractArea.get_overlapping_bodies()[0]
				interact(action_object)
			if $CarryArea.get_overlapping_bodies():
				carry_objext = $CarryArea.get_overlapping_bodies()[0]
				$GrabPoint.set_node_b(carry_objext.get_path())
			
			pass
		
		pass
	pass
	
func interact(action_object: Node):
	if action_object.is_in_group("plug"):
		if carry_objext:
			action_object.connect_plug(carry_objext)
		else:
			action_object.disconnect_plug()
			
		pass
	pass
