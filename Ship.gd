
extends RigidBody2D

var weapons_cooldown = [15, 90, 300, 400]
var primary_cooldown = 0
var secondary_cooldown = -1
var special_cooldown = 0
var primary = [preload("res://bullet2.scn"), preload("res://bullet.scn"),preload("res://bullet3.scn"),preload("res://bullet4.scn")]
var primary_weapon = 3
var secondary = preload("res://missil1.scn")
var energypack = preload("res://energy_pack.gd")
var lightgun_powerup = preload("res://lightgun_powerup.gd")
var autocannon_powerup = preload("res://autocannon_powerup.gd")
var heavycannon_powerup = preload("res://heavycannon_powerup.gd")
var missile_powerup = preload("res://missile_powerup.gd")
var explosion = preload("res://ExplosionLarge1.scn")
var small_explosion = preload("res://Explosion2.scn")
var enemy_class = preload("res://eneimgo.gd")
var hp = 300
var max_hp = 300.0
var death_countdown = 120
var alive = true
var target = null
const is_projectile = 0

const absolute = 0
const relative = 1

export(int, "Absolute", "Relative") var direction_mode = absolute

func _ready():
	set_fixed_process(true)
	pass

func _fixed_process(delta):

	get_node("Area2D").set_global_pos(get_viewport().get_mouse_pos() + get_node("Camera2D").get_camera_screen_center() - get_viewport_rect().size/2 )

	var ang = get_angle_to(get_viewport().get_mouse_pos() + get_node("Camera2D").get_camera_screen_center() - get_viewport_rect().size/2 )

	rotate(ang*delta*6)
	
	if alive:	
		if Input.is_action_pressed("open_menu"):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			get_node("/root/Node/HUD/PopupPanel").show()
			get_tree().set_pause(true)
		
		if direction_mode == relative:
			if Input.is_action_pressed("forward"):
				apply_impulse(get_pos(),4*Vector2(sin( get_rot()), cos( get_rot())))
		
			if Input.is_action_pressed("backward"):
				apply_impulse(get_pos(),2*Vector2(-sin( get_rot()), -cos( get_rot())))
				
			if Input.is_action_pressed("left"):
				apply_impulse(get_pos(),3*Vector2(sin( get_rot()+PI/2), cos( get_rot()+PI/2)))
		
			if Input.is_action_pressed("right"):
				apply_impulse(get_pos(),3*Vector2(sin( get_rot()-PI/2), cos( get_rot()-PI/2)))
				
		if direction_mode == absolute:
			var movement_vector = Vector2(0,0)
			if Input.is_action_pressed("forward"):
				movement_vector += Vector2(0,-1)
		
			if Input.is_action_pressed("backward"):
				movement_vector += Vector2(0,1)
				
			if Input.is_action_pressed("left"):
				movement_vector += Vector2(-1,0)
		
			if Input.is_action_pressed("right"):
				movement_vector += Vector2(1,0)
	
			if movement_vector.length() > 0:
				movement_vector = movement_vector.normalized()*3
				movement_vector -= Vector2(-sin( get_rot()), -cos( get_rot())) #TODO: fixear esto, mueve el jugador hacia adelante un poquito a pesar de la direccion elegida
				apply_impulse(get_pos(), movement_vector)
	
		if Input.is_action_pressed("fire_primary") and primary_cooldown==0:
			var bullet = primary[primary_weapon].instance()
			bullet.owner = self
			bullet.set_pos(get_pos() + Vector2(sin(get_rot()),cos(get_rot())).normalized()*40)
			bullet.set_rot(get_rot()+(randf()*0.2-0.1) )
			bullet.set_linear_velocity(Vector2(sin(bullet.get_rot()),cos(bullet.get_rot()))*600 + get_linear_velocity())
			get_node("/root/Node").add_child(bullet)
			primary_cooldown = weapons_cooldown[0]
			
	
		if primary_cooldown > 0:
			primary_cooldown -= 1
		
		if Input.is_action_pressed("fire_secondary") and secondary_cooldown==0:
			var missile = secondary.instance()
			missile.owner = self
			#missile.target = target
			missile.set_pos(get_pos() + Vector2(sin(get_rot()+1),cos(get_rot()+1)).normalized()*20)
			missile.set_rot(get_rot() + 1)
			missile.set_linear_velocity(Vector2(sin(missile.get_rot()),cos(missile.get_rot()))*100 + get_linear_velocity())
			
			var missile2 = secondary.instance()
			missile2.owner = self
			#missile2.target = target
			missile2.set_pos(get_pos() + Vector2(sin(get_rot()-1),cos(get_rot()-1)).normalized()*20)
			missile2.set_rot(get_rot() - 1)
			missile2.set_linear_velocity(Vector2(sin(missile2.get_rot()),cos(missile2.get_rot()))*100 + get_linear_velocity())
			
			get_node("/root/Node").add_child(missile)
			get_node("/root/Node").add_child(missile2)
			secondary_cooldown = weapons_cooldown[1]
	
		if secondary_cooldown > 0:
			secondary_cooldown -= 1
			
		if Input.is_action_pressed("fire_special") and special_cooldown==0:
			special_cooldown = weapons_cooldown[2]
	
		if special_cooldown > 0:
			special_cooldown -= 1
	
		get_node("healthbar").set_scale(Vector2(hp/max_hp,1))
	
	if hp <= 0:
		hp = 0
		death_countdown -= 1
		var chance = floor(rand_range(0,10))
		if chance == 0 and death_countdown > 50:
			var boom = small_explosion.instance()
			boom.set_pos(get_pos())
			boom.set_emitting(true)
			get_node("/root/Node").add_child(boom)
		if death_countdown == 60:
			hide()
			alive = false
			var boom = explosion.instance()
			boom.set_pos(get_pos())
			boom.set_emitting(true)
			get_node("/root/Node").add_child(boom)

		if death_countdown == 0:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			get_tree().change_scene("res://splash_screen.scn")



func _integrate_forces(state):
	for i in range(state.get_contact_count()):
		var contact = state.get_contact_collider_object(i)
		if contact and contact extends energypack:
			hp += contact.hp
			contact.hp = 0
		if contact and contact extends lightgun_powerup:
			primary_weapon = 0
			weapons_cooldown[0] = 5
			contact.hp = 0
				
		if contact and contact extends autocannon_powerup:
			primary_weapon = 1
			weapons_cooldown[0] = 12
			contact.hp = 0
			
		if contact and contact extends heavycannon_powerup:
			primary_weapon = 2
			weapons_cooldown[0] = 20
			contact.hp = 0

		if contact and contact extends missile_powerup:
			secondary_cooldown = 0
			contact.hp = 0

func _on_Area2D_body_enter( body ):
	pass
	if body extends enemy_class:
		target = body
