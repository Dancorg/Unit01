
extends RigidBody2D

var weapons_cooldown = [10, 40, 300]
var primary_cooldown = 0
var secondary_cooldown = 0
var special_cooldown = 0
var primary = preload("res://bullet.scn")
var energypack = preload("res://energy_pack.gd")
var hp = 1000

func _ready():
	set_fixed_process(true)
	pass

func _fixed_process(delta):
	
	var ang = get_angle_to(get_viewport().get_mouse_pos())
	rotate(ang*delta*6)
	
	if Input.is_action_pressed("forward"):
		apply_impulse(get_pos(),4*Vector2(sin( get_rot()), cos( get_rot())))

	if Input.is_action_pressed("backward"):
		apply_impulse(get_pos(),2*Vector2(-sin( get_rot()), -cos( get_rot())))
		
	if Input.is_action_pressed("left"):
		apply_impulse(get_pos(),3*Vector2(sin( get_rot()+PI/2), cos( get_rot()+PI/2)))

	if Input.is_action_pressed("right"):
		apply_impulse(get_pos(),3*Vector2(sin( get_rot()-PI/2), cos( get_rot()-PI/2)))

	if Input.is_action_pressed("fire_primary") and primary_cooldown==0:
		var bullet = primary.instance()
		bullet.owner = self
		bullet.set_pos(get_pos() + Vector2(sin(get_rot()),cos(get_rot())).normalized()*40)
		bullet.set_rot(get_rot()+(randf()*0.2-0.1) )
		bullet.set_linear_velocity(Vector2(sin(bullet.get_rot()),cos(bullet.get_rot()))*600 + get_linear_velocity())
		get_node("/root/Node").add_child(bullet)
		primary_cooldown = weapons_cooldown[0]

	if primary_cooldown > 0:
		primary_cooldown -= 1
	
	if Input.is_action_pressed("fire_secondary") and secondary_cooldown==0:
		secondary_cooldown = weapons_cooldown[1]

	if secondary_cooldown > 0:
		secondary_cooldown -= 1
		
	if Input.is_action_pressed("fire_special") and special_cooldown==0:
		special_cooldown = weapons_cooldown[2]

	if special_cooldown > 0:
		special_cooldown -= 1

	get_node("healthbar").set_scale(Vector2(hp/1000.0,1))
	
	if hp <= 0:
		get_tree().change_scene("res://splash_screen.scn")



func _integrate_forces(state):
	for i in range(state.get_contact_count()):
		var contact = state.get_contact_collider_object(i)
		if contact and contact extends energypack:
			hp += contact.hp
			contact.hp = 0
