
extends RigidBody2D

var range_timer = 60
var hp = 50
var damage = 50
var spark = preload("res://spark3.scn")
var owner = null
const is_projectile = 1

func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	range_timer -= 1
	if range_timer == 0 or hp <= 0:
		queue_free()

func _integrate_forces(state):
	for i in range(state.get_contact_count()):
		var contact = state.get_contact_collider_object(i)
		if contact.is_projectile == 0:
			hp = 0
		if contact:
			contact.hp -= damage
		var chispa = spark.instance()
		chispa.set_pos(get_pos())
		chispa.set_emitting(true)
		chispa.set_rot(get_rot())
		get_node("/root/Node").add_child(chispa)