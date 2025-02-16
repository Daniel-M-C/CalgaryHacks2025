extends CharacterBody2D
class_name Player

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const MAX_HP = 100
var hp = MAX_HP
var carry_objext = ""
var not_landed_yet = false
var still_jumping = false
var in_water = false
var drowning_time = 5
var temp_sprite = ""
var caotye_time = 0.5

signal Died
@onready var sprite = $Sprite/AnimatedSprite2D

func _ready():
	pass

func _physics_process(delta):

	if carry_objext:
		if global_position.x - carry_objext.global_position.x > 50 or global_position.y - carry_objext.global_position.y > 50:
			$GrabPoint.set_node_b("")
			carry_objext = ""
	
	
	if not is_on_floor():
		caotye_time -= 1 *delta
		not_landed_yet = true
		velocity += get_gravity() * delta
		if velocity.y > 0:
			if temp_sprite == "":
				sprite.play("falling")
			pass # play jump up
		if velocity.y < 0:
			if !still_jumping and temp_sprite == "":
				sprite.play("jumping")
			pass # play jump down
	elif not_landed_yet and temp_sprite == "":
		sprite.play("fall")
		not_landed_yet = false

	if Input.is_action_just_pressed("up") and ((is_on_floor() or in_water) or caotye_time > 0):
		velocity.y = JUMP_VELOCITY
		caotye_time = -10
		$Audio/JumpSound.play()
		if temp_sprite == "":
			sprite.play("jump")
			still_jumping = true
	if Input.is_action_pressed("down") and (!is_on_floor() or in_water):
		velocity.y *= 1.25
		
	
	var direction = Input.get_axis("left", "right")
	if direction:
		if velocity.y == 0 and is_on_floor() and temp_sprite == "":
			sprite.play("walk")
		velocity.x = direction * SPEED
		if velocity.x < 0:
			sprite.scale.x = 1
			$Tail.position.x = 7.0
		elif velocity.x > 0:
			sprite.scale.x = -1
			$Tail.position.x = -2.0
	else:
		if is_on_floor():
			if Input.is_action_pressed("down") and temp_sprite == "":
				sprite.play("sit")
			elif temp_sprite == "":
				sprite.play("idle")
			caotye_time = 0.5
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if in_water:
		velocity.x /= 1.25
		velocity.y /= 1.25
	move_and_slide()
	
	if in_water:
		if drowning_time > 0:
			drowning_time -= 1 * delta
		else:
			take_damage(10)
			drowning_time = 2
			pass
		

func take_damage(damage):
	hp -= damage
	temp_sprite = "hurting"
	var temp = sprite.get_animation()
	$Audio/HurtSound.play()
	sprite.play("damage")
	await sprite.animation_finished
	sprite.play(temp)
	temp_sprite = "" 
	if hp < 40:
		$Sprite/GPUParticles2D.emitting = true
	
	if hp < 0 : 
		# TODO play an animation maybe?
		Died.emit()
		hp = 100
		$Sprite/GPUParticles2D.emitting = false
		pass
		
func heal_health(amount):
	if amount:
		hp += amount
	else:
		hp += 10
	if hp > 40:
		$Sprite/GPUParticles2D.emitting = false


func _on_hurt_box_area_entered(area) -> void:
	if area.get("damage"):
		take_damage(area.damage)
	else:
		take_damage(10)
	
func _input(event):
	
	if event.is_action_pressed("action"):
		$Audio/BarkSound.play()
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
	pass 


func _on_hurt_box_body_entered(body):
	if body.get("damage"):
		take_damage(body.damage)
	else:
		take_damage(10)
	pass # Replace with function body.
