
extends RigidBody2D

var hp=0
var max_hp=0
var target = null
var player_class = preload("res://Ship.gd")
var wall_class = preload("res://wall.gd")
var this_class = load("res://eneimgo.gd")
var energypack_class = preload("res://energy_pack.gd")
var energypack = preload("res://energy_pack.scn")

var primary 
var explosion

var weapons_cooldown = [30]
var primary_cooldown = 0
var primary_vo = 400
var engine = 3
var change_direction_timer = 60
var sideways_direction = PI / 2
var engage_distance = 600
var rotate_speed = 3

const TYPE1=0
const TYPE2=1
const TYPE3=2
const TYPE4=3
const no1=0
const no2=1
export(int, "no","no") var no=no1
export(int, "type1", "type2", "type3", "type4") var type=TYPE1


func _ready():
	if type==TYPE1:
		hp=30
		max_hp=30.0
		weapons_cooldown = [40]
		primary_vo = 300
		engage_distance = 400
		engine = 3
		primary = preload("res://bullet2.scn")
		explosion = preload("res://Explosion.scn")
		rotate_speed = 3
	if type==TYPE2:
		hp=60
		max_hp=60.0
		weapons_cooldown = [30]
		primary_vo = 400
		engage_distance = 500
		engine = 3
		primary = preload("res://bullet2.scn")
		explosion = preload("res://Explosion2.scn")
		rotate_speed = 2.5
	if type==TYPE3:
		hp=300
		max_hp=300.0
		weapons_cooldown = [60]
		primary_vo = 600
		engage_distance = 700
		engine = 7
		primary = preload("res://bullet3.scn")
		explosion = preload("res://Explosion3.scn")
		rotate_speed = 1.5
	if type==TYPE4:
		hp=200
		max_hp=200.0
		weapons_cooldown = [10]
		primary_vo = 500
		engage_distance = 600
		engine = 5
		primary = preload("res://bullet2.scn")
		explosion = preload("res://Explosion4.scn")
		rotate_speed = 2
	set_fixed_process(true)


func _fixed_process(delta):
	if target and target extends player_class:
		var lead_position = get_lead_position(self, target, primary_vo)
		var ang = get_angle_to(lead_position)
		var distance = sqrt( pow(lead_position[0] - get_pos()[0],2) + pow(lead_position[1] - get_pos()[1],2))
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
				if change_direction_timer == 0:
					if type==TYPE2:
						change_direction_timer = 20 + round(rand_range(0, 40))
						sideways_direction = sign(rand_range(-1,1)) * rand_range(PI/4, PI*(3/4))
					if type==TYPE3:
						change_direction_timer = 30 + round(rand_range(0, 90))
						sideways_direction = sign(rand_range(-1,1)) * rand_range(PI/4, PI*(3/4))
					if type==TYPE4:
						change_direction_timer = 10 + round(rand_range(0, 40))
						sideways_direction = sign(rand_range(-1,1)) * rand_range(PI/2, PI*(3/4))
					
				apply_impulse(get_pos(),engine*Vector2(sin( get_rot() + sideways_direction), cos( get_rot() + sideways_direction)))
		
		if  distance < engage_distance and abs(ang) < 0.03 and line_of_sight:
			if primary_cooldown == 0:
				primary_cooldown = weapons_cooldown[0]
				if type==TYPE1:
					var bullet1 = primary.instance()
					bullet1.set_pos(get_pos() + Vector2(sin(get_rot()),cos(get_rot())).normalized()*30)
					bullet1.set_rot(get_rot()+(randf()*0.3-0.15) )
					bullet1.set_linear_velocity(Vector2(sin(bullet1.get_rot()),cos(bullet1.get_rot()))*primary_vo + get_linear_velocity())
					get_node("/root/Node").add_child(bullet1)
					
				if type==TYPE2:
					var bullet1 = primary.instance()
					bullet1.set_pos(get_pos() + Vector2(sin(get_rot()-0.5),cos(get_rot()-0.5)).normalized()*20)
					bullet1.set_rot(get_rot()+(randf()*0.2-0.1) )
					bullet1.set_linear_velocity(Vector2(sin(bullet1.get_rot()),cos(bullet1.get_rot()))*primary_vo + get_linear_velocity())
					get_node("/root/Node").add_child(bullet1)
					
					var bullet2 = primary.instance()
					bullet2.set_pos(get_pos() + Vector2(sin(get_rot()+0.5),cos(get_rot()+0.5)).normalized()*20)
					bullet2.set_rot(get_rot()+(randf()*0.2-0.1) )
					bullet2.set_linear_velocity(Vector2(sin(bullet2.get_rot()),cos(bullet2.get_rot()))*primary_vo + get_linear_velocity())
					get_node("/root/Node").add_child(bullet2)
					
				if type==TYPE3:
					var bullet1 = primary.instance()
					bullet1.set_pos(get_pos() + Vector2(sin(get_rot()),cos(get_rot())).normalized()*30)
					bullet1.set_rot(get_rot()+(randf()*0.2-0.1) )
					bullet1.set_linear_velocity(Vector2(sin(bullet1.get_rot()),cos(bullet1.get_rot()))*primary_vo + get_linear_velocity())
					get_node("/root/Node").add_child(bullet1)
					
				if type==TYPE4:
					var bullet1 = primary.instance()
					bullet1.set_pos(get_pos() + Vector2(sin(get_rot()),cos(get_rot())).normalized()*30)
					bullet1.set_rot(get_rot()+(randf()*0.5-0.25) )
					bullet1.set_linear_velocity(Vector2(sin(bullet1.get_rot()),cos(bullet1.get_rot()))*primary_vo + get_linear_velocity())
					get_node("/root/Node").add_child(bullet1)
		
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

func _integrate_forces(state):
	for i in range(state.get_contact_count()):
		var contact = state.get_contact_collider_object(i)
		if contact and contact extends energypack_class:
			hp += contact.hp
			contact.hp = 0

func is_clear_line_of_sight(target):
	var space = get_world_2d().get_space()
	var space_state = Physics2DServer.space_get_direct_state( space )

	var ray = space_state.intersect_ray(get_pos(), target, [self])

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
	return Vector2(target.get_pos()[0] + target.get_linear_velocity()[0] * t, target.get_pos()[1] + target.get_linear_velocity()[1] * t)