
extends RigidBody2D

const is_projectile = 1
var range_timer = 40
var hp = 10
var damage = 15
var spark = preload("res://spark3.scn")
var energypack_class = preload("res://energy_pack.gd")

var submunition = preload("res://bullet2.scn")
var submunition_amount = 10

var submunition_timer = 10

var owner = null

func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	range_timer -= 1
	submunition_timer -= 1
	
	if submunition_timer == 0:
		hp = 0
		for i in range(submunition_amount):
			var _sign = pow(-1,i)
			var submunition_instance = submunition.instance()
			submunition_instance.set_rot(get_rot() + i * _sign * 0.1)
			submunition_instance.set_pos(get_pos() + Vector2(sin(submunition_instance.get_rot()),cos(submunition_instance.get_rot())).normalized()*30)
			submunition_instance.set_linear_velocity(Vector2(sin(submunition_instance.get_rot()),cos(submunition_instance.get_rot())).normalized()*100 + get_linear_velocity())
			submunition_instance.owner = owner
			get_node("/root/Node").add_child(submunition_instance)
	
	if range_timer == 0 or hp <= 0:
		queue_free()

func _integrate_forces(state):
	for i in range(state.get_contact_count()):
		var contact = state.get_contact_collider_object(i)
		if contact: 
			contact.hp -= damage
		if contact.is_projectile == 0:
			hp = 0
		var chispa = spark.instance()
		chispa.set_pos(get_pos())
		chispa.set_emitting(true)
		chispa.set_rot(get_rot())
		get_node("/root/Node").add_child(chispa)
