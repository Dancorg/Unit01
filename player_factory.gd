
extends Node2D

var death_countdown = 150

var explosion = [preload("res://Explosion2.scn"),preload("res://Explosion4.scn"), preload("res://ExplosionLarge1.scn")]
var player_class = preload("res://Ship.gd")
var player_inside = false

var fixing_countdown = 10

func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	var player = get_node("/root/Node/ship_blue")
	if get_node("wall").hp < 0:
		get_node("wall").hp = 0
	get_node("wall/healthbar").set_scale(Vector2(get_node("wall").hp/get_node("wall").max_hp,1))
	
	if get_node("wall").hp <= 0:
		death_countdown -= 1
		var chance = floor(rand_range(0,10))
		if chance == 0:
			var small_boom = explosion[floor(rand_range(0,2))].instance()
			small_boom.set_pos(get_pos() + Vector2(randf()*120,randf()*120) - Vector2(60,60))
			small_boom.set_emitting(true)
			get_node("/root/Node").add_child(small_boom)
		if death_countdown <= 1:
			var boom = explosion[2].instance()
			boom.set_pos(get_pos())
			boom.set_emitting(true)
			get_node("/root/Node").add_child(boom)
			queue_free()
	
	if sqrt( pow(player.get_pos()[0] - get_pos()[0],2) + pow(player.get_pos()[1] - get_pos()[1],2)) < 50:
		player_inside = true
	else:
		player_inside = false
		
	if player_inside:
		
		if player.hp < player.max_hp:
			get_node("wall/Particles2D").set_emitting(true)
			player.hp += 1
		else:
			get_node("wall/Particles2D").set_emitting(false)



