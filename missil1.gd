
extends RigidBody2D

var range_timer = 120
var hp = 30
var damage = 70
var enemy_class = preload("res://eneimgo.gd")
var spark = preload("res://Explosion.scn")
var trail_preload = preload("res://trail1.scn")
var trail
var owner = null
var target = null
var detector = null
const is_projectile = 1

func _ready():
	trail = trail_preload.instance()
	trail.set_emitting(true)
	get_node("/root/Node").add_child(trail)
	set_fixed_process(true)
	
func _fixed_process(delta):
	var ang
	if target != null and str(target) != "[Object:0]":
		ang = get_angle_to(target.get_pos())
		get_node("targetArea/target").set_global_pos(target.get_pos())
		get_node("targetArea/target").show()
	elif detector != null and str(detector) != "[Object:0]":
		target = detector
		ang = get_angle_to(target.get_pos())
	#elif owner.target != null and str(owner.target) != "[Object:0]":
		#target = owner.target
		#ang = get_angle_to(target.get_pos())
	else:
		get_node("targetArea/target").hide()
		ang = get_angle_to(get_viewport().get_mouse_pos() + get_node("/root/Node/ship_blue/Camera2D").get_camera_screen_center() - get_viewport_rect().size/2)
		
	rotate(min(abs(ang),8*delta)*sign(ang))
	apply_impulse(get_pos(),10*Vector2(sin( get_rot()), cos( get_rot())))
	
	range_timer -= 1
	trail.set_pos(get_pos())
	trail.set_rot(get_rot())
	if range_timer == 0 or hp <= 0:
		trail.set_emitting(false)
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


func _on_targetArea_body_enter( body ):
	if body extends enemy_class:
		detector = body
