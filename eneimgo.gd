
extends RigidBody2D

var hp=0
var max_hp=0
var target = null
var player_class = preload("res://Ship.gd")
var missile_class = preload("res://missil1.gd")
var wall_class = preload("res://wall.gd")
var factory_class = preload("res://factory.gd")
var this_class = load("res://eneimgo.gd")
var energypack_class = preload("res://energy_pack.gd")
var energypack = preload("res://energy_pack.scn")
const is_projectile = 0

var primary 
var explosion
var death_countdown = 300

var weapons_cooldown = [30]
var primary_cooldown = 0
var primary_vo = 400
var engine = 3
var change_direction_timer = 60
var sideways_direction = PI / 2
var engage_distance = 600
var rotate_speed = 3
var fire_angle = 0.03

const TYPE0=0
const TYPE1=1
const TYPE2=2
const TYPE3=3
const TYPE4=4
const TYPE5=5
const TYPE6=6
const TYPE7=7

export(int, "type0", "type1", "type2", "type3", "type4", "type5", "type6", "type7") var type=TYPE0


func _ready():
	if type == TYPE0:
		hp = 40
		max_hp = 40.0
		weapons_cooldown = [30]
		primary_vo = 400
		engage_distance = 500
		engine = 2
		primary = preload("res://bullet2.scn")
		explosion = preload("res://Explosion5.scn")
		rotate_speed = 2.5
		fire_angle = 0.03
	if type == TYPE1:
		hp = 30
		max_hp = 30.0
		weapons_cooldown = [40]
		primary_vo = 600
		engage_distance = 700
		engine = 5
		primary = preload("res://bullet2.scn")
		explosion = preload("res://Explosion.scn")
		rotate_speed = 3
		fire_angle = 0.03
	if type == TYPE2:
		hp = 60
		max_hp = 60.0
		weapons_cooldown = [30]
		primary_vo = 400
		engage_distance = 500
		engine = 3
		primary = preload("res://bullet2.scn")
		explosion = preload("res://Explosion2.scn")
		rotate_speed = 2.5
		fire_angle = 0.03
	if type == TYPE3:
		hp = 300
		max_hp = 300.0
		weapons_cooldown = [60]
		primary_vo = 600
		engage_distance = 700
		engine = 7
		primary = preload("res://bullet3.scn")
		explosion = preload("res://Explosion3.scn")
		rotate_speed = 1.5
		fire_angle = 0.02
	if type == TYPE4:
		hp = 200
		max_hp = 200.0
		weapons_cooldown = [10]
		primary_vo = 500
		engage_distance = 600
		engine = 5
		primary = preload("res://bullet.scn")
		explosion = preload("res://Explosion4.scn")
		rotate_speed = 2
		fire_angle = 0.05
	if type == TYPE5:
		hp = 400
		max_hp = 400.0
		weapons_cooldown = [20]
		primary_vo = 700
		engage_distance = 800
		engine = 0
		primary = preload("res://bullet3.scn")
		explosion = preload("res://Explosion2.scn")
		rotate_speed = 1
		fire_angle = 0.03
	if type == TYPE6:
		hp = 300
		max_hp = 300.0
		weapons_cooldown = [5]
		primary_vo = 500
		engage_distance = 500
		engine = 0
		primary = preload("res://bullet2.scn")
		explosion = preload("res://Explosion3.scn")
		rotate_speed = 3
		fire_angle = 0.07
	if type == TYPE7:
		hp = 120
		max_hp = 120.0
		weapons_cooldown = [90]
		primary_vo = 1000
		engage_distance = 900
		engine = 3
		primary = preload("res://missil2.scn")
		explosion = preload("res://Explosion3.scn")
		rotate_speed = 3
		fire_angle = 0.1
		
	set_fixed_process(true)

func _fixed_process(delta):
	if target and (target extends player_class or target extends missile_class):
	
		var lead_position = get_lead_position(self, target, primary_vo)
		var distance = sqrt( pow(lead_position[0] - get_pos()[0],2) + pow(lead_position[1] - get_pos()[1],2))
		
		if distance > engage_distance:
			lead_position = target.get_pos()
			
		var ang = get_angle_to(lead_position)
		
		rotate(min(abs(ang),rotate_speed*delta)*sign(ang))
		
		var line_of_sight = is_clear_line_of_sight(target.get_pos())

		if not line_of_sight:
			change_direction_timer -= 1
			if change_direction_timer == 0:
				change_direction_timer = 60 + round(rand_range(0, 180))
				sideways_direction = sign(rand_range(-1,1)) * rand_range(PI/2, PI*(3/4))
				
			apply_impulse(get_pos(),engine*Vector2(sin( get_rot() + sideways_direction), cos( get_rot() + sideways_direction)))
		
		if abs(ang) < 0.2 and line_of_sight:
			if type==TYPE1:
				apply_impulse(get_pos(),engine*Vector2(sin( get_rot()), cos( get_rot())))
			else:
				change_direction_timer -= 1
				if change_direction_timer <= 0:
					if type==TYPE2:
						change_direction_timer = 20 + round(rand_range(0, 40))
						sideways_direction = sign(rand_range(-1,1)) * rand_range(PI/4, PI*(3/4))
					if type==TYPE3 or type==TYPE0 or type==TYPE7:
						change_direction_timer = 30 + round(rand_range(0, 90))
						sideways_direction = sign(rand_range(-1,1)) * rand_range(PI/4, PI*(3/4))
					if type==TYPE4:
						change_direction_timer = 10 + round(rand_range(0, 40))
						sideways_direction = sign(rand_range(-1,1)) * rand_range(PI/2, PI*(3/4))
					
				apply_impulse(get_pos(),engine*Vector2(sin( get_rot() + sideways_direction), cos( get_rot() + sideways_direction)))
		
		if  distance < engage_distance and abs(ang) < fire_angle and line_of_sight:
			if primary_cooldown == 0:
				primary_cooldown = weapons_cooldown[0]
				if type==TYPE0:
					var bullet1 = primary.instance()
					bullet1.set_pos(get_pos() + Vector2(sin(get_rot()),cos(get_rot())).normalized()*20)
					bullet1.set_rot(get_rot()+(randf()*0.4-0.2) )
					bullet1.set_linear_velocity(Vector2(sin(bullet1.get_rot()),cos(bullet1.get_rot()))*primary_vo + get_linear_velocity() )
					get_node("/root/Node").add_child(bullet1)
					
				if type==TYPE1:
					var bullet1 = primary.instance()
					bullet1.set_pos(get_pos() + Vector2(sin(get_rot()),cos(get_rot())).normalized()*30)
					bullet1.set_rot(get_rot()+(randf()*0.3-0.15) )
					bullet1.set_linear_velocity(Vector2(sin(bullet1.get_rot()),cos(bullet1.get_rot()))*primary_vo + get_linear_velocity() )
					get_node("/root/Node").add_child(bullet1)
					
				if type==TYPE2:
					var bullet1 = primary.instance()
					bullet1.set_pos(get_pos() + Vector2(sin(get_rot()-0.5),cos(get_rot()-0.5)).normalized()*20)
					bullet1.set_rot(get_rot()+(randf()*0.2-0.1) )
					bullet1.set_linear_velocity(Vector2(sin(bullet1.get_rot()),cos(bullet1.get_rot()))*primary_vo + get_linear_velocity() )
					get_node("/root/Node").add_child(bullet1)
					
					var bullet2 = primary.instance()
					bullet2.set_pos(get_pos() + Vector2(sin(get_rot()+0.5),cos(get_rot()+0.5)).normalized()*20)
					bullet2.set_rot(get_rot()+(randf()*0.2-0.1) )
					bullet2.set_linear_velocity(Vector2(sin(bullet2.get_rot()),cos(bullet2.get_rot()))*primary_vo + get_linear_velocity() )
					get_node("/root/Node").add_child(bullet2)
					
				if type==TYPE3:
					var bullet1 = primary.instance()
					bullet1.set_pos(get_pos() + Vector2(sin(get_rot()),cos(get_rot())).normalized()*30)
					bullet1.set_rot(get_rot()+(randf()*0.2-0.1) )
					bullet1.set_linear_velocity(Vector2(sin(bullet1.get_rot()),cos(bullet1.get_rot()))*primary_vo + get_linear_velocity() )
					get_node("/root/Node").add_child(bullet1)
					
				if type==TYPE4:
					var bullet1 = primary.instance()
					bullet1.set_pos(get_pos() + Vector2(sin(get_rot()),cos(get_rot())).normalized()*40)
					bullet1.set_rot(get_rot()+(randf()*0.5-0.25) )
					bullet1.set_linear_velocity(Vector2(sin(bullet1.get_rot()),cos(bullet1.get_rot()))*primary_vo + get_linear_velocity() )
					get_node("/root/Node").add_child(bullet1)
					
				if type==TYPE5:
					var bullet1 = primary.instance()
					bullet1.set_pos(get_pos() + Vector2(sin(get_rot()),cos(get_rot())).normalized()*40)
					bullet1.set_rot(get_rot()+(randf()*0.1-0.05) )
					bullet1.set_linear_velocity(Vector2(sin(bullet1.get_rot()),cos(bullet1.get_rot()))*primary_vo + get_linear_velocity() )
					get_node("/root/Node").add_child(bullet1)
		
				if type==TYPE6:
					var bullet1 = primary.instance()
					bullet1.set_pos(get_pos() + Vector2(sin(get_rot()),cos(get_rot())).normalized()*30)
					bullet1.set_rot(get_rot()+(randf()*0.4-0.2) )
					bullet1.set_linear_velocity(Vector2(sin(bullet1.get_rot()),cos(bullet1.get_rot()))*primary_vo + get_linear_velocity() )
					get_node("/root/Node").add_child(bullet1)
					
				if type==TYPE7:
					var missile = primary.instance()
					missile.set_pos(get_pos() + Vector2(sin(get_rot()),cos(get_rot())).normalized()*30)
					missile.set_rot(get_rot() )
					missile.set_linear_velocity(Vector2(sin(missile.get_rot()),cos(missile.get_rot()))*100 + get_linear_velocity() )
					missile.target = target
					get_node("/root/Node").add_child(missile)
	else:
		for i in get_node("/root/Node").get_children():
			if i extends player_class:
				target = i
				
	if primary_cooldown > 0:
		primary_cooldown -= 1

	get_node("healthbar").set_scale(Vector2(hp/max_hp,1))

	if hp <= 0:
		var fx = explosion.instance()
		fx.set_emitting(true)
		fx.set_pos(get_pos())
		fx.set_rot(get_rot())
		get_node("/root/Node").add_child(fx)
		
		if int(rand_range(0,2)) == 0:
			var energy = energypack.instance()
			energy.set_pos(get_pos())
			get_node("/root/Node").add_child(energy)
			
		queue_free()
	if hp > max_hp:
		hp = max_hp

func _integrate_forces(state):
	for i in range(state.get_contact_count()):
		var contact = state.get_contact_collider_object(i)
		if contact and contact extends energypack_class:
			hp += contact.hp
			contact.hp = 0
		if contact and contact extends wall_class:
			change_direction_timer = 30
			var normal = state.get_contact_local_normal(i)
			sideways_direction = atan2(normal[0],normal[1]) - get_rot()

func is_clear_line_of_sight(target):
	var space = get_world_2d().get_space()
	var space_state = Physics2DServer.space_get_direct_state( space )

	var ray = space_state.intersect_ray(get_pos(), target, [self])

	if not "collider" in ray:
		return true
	var collider = ray.collider
	


	if collider:
		if collider extends wall_class or collider extends this_class :
			return false
		else:
			return true
	else:
		return true


func get_lead_position(shooter, target, bullet_speed):
	var totarget =  Vector2(target.get_pos()[0] - shooter.get_pos()[0], target.get_pos()[1] - shooter.get_pos()[1])

	var a = (target.get_linear_velocity()[0] * target.get_linear_velocity()[0] + target.get_linear_velocity()[1] * target.get_linear_velocity()[1]) - (bullet_speed * bullet_speed)
	var b = 2 * (target.get_linear_velocity()[0] * totarget[0])
	var c = totarget[0] * totarget[0] + totarget[1] * totarget[1]

	var p = -b / (2 * a)
	var q = sqrt((b * b) - 4 * a * c) / (2 * a)

	var t1 = p - q
	var t2 = p + q
	var t

	if (t1 > t2 and t2 > 0):
		t = t2
	else:
		t = t1
		
	return Vector2(target.get_pos()[0] + target.get_linear_velocity()[0] * t - shooter.get_linear_velocity()[0] * t, target.get_pos()[1] + target.get_linear_velocity()[1] * t - shooter.get_linear_velocity()[1] * t)

func _on_target_area_body_enter( body ):
	if body extends missile_class:
		target = body
