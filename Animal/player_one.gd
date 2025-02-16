extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const MAX_HP = 100
var hp = MAX_HP
var carry_objext = ""
var not_landed_yet = false
var still_jumping = false
var in_water = false

@onready var sprite = $Sprite/AnimatedSprite2D

func _physics_process(delta):
	print(in_water)
	if carry_objext:
		if global_position.x - carry_objext.global_position.x > 50 or global_position.y - carry_objext.global_position.y > 50:
			$GrabPoint.set_node_b("")
			carry_objext = ""
	
	
	if not is_on_floor():
		not_landed_yet = true
		velocity += get_gravity() * delta
		if velocity.y > 0:
			sprite.play("falling")
			pass # play jump up
		if velocity.y < 0:
			if !still_jumping:
				sprite.play("jumping")
			pass # play jump down
	elif not_landed_yet:
		sprite.play("fall")
		not_landed_yet = false

	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$Audio/JumpSound.play()
		sprite.play("jump")
		still_jumping = true
		pass # play jump start
	
	var direction = Input.get_axis("left", "right")
	if direction:
		if velocity.y == 0 and is_on_floor():
			sprite.play("walk")
			pass # play walking
		velocity.x = direction * SPEED
		if velocity.x < 0:
			sprite.scale.x = 1
			$Tail.position.x = 7.0
		elif velocity.x > 0:
			sprite.scale.x = -1
			$Tail.position.x = -2.0
	else:
		if is_on_floor():
			sprite.play("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if in_water:
		velocity.x /= 1.25
		velocity.y /= 1.25
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


func _on_animated_sprite_2d_animation_finished():
	still_jumping = false
	pass # Replace with function body.
