
extends Node2D

var death_countdown = 150

var wave_count = 0

var timer_warmup = -1
var points = 100
var min_level = 0
var max_level = 0

var next_product = 0

var enemies = [preload("res://enemigo0.scn"), preload("res://eneimgo.scn"), preload("res://enemigo2.scn"),preload("res://enemigo3.scn"),preload("res://enemigo4.scn")]
var explosion = [preload("res://Explosion2.scn"),preload("res://Explosion4.scn"), preload("res://ExplosionLarge1.scn")]

export(int) var timer_wave=120

func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	if get_node("wall").hp < 0:
		get_node("wall").hp = 0
	get_node("wall/healthbar").set_scale(Vector2(get_node("wall").hp/get_node("wall").max_hp,1))
	
	if timer_wave >= 0:
		get_node("wall/Label").set_text("OFFLINE-" + str(ceil(timer_wave/60)))
	else:
		get_node("wall/Label").set_text("ONLINE")
		
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
		

	if timer_wave <= 0:
		if timer_warmup == -1:
			next_product = floor(rand_range(min_level,max_level))
			get_node("wall/Particles2D").set_emitting(true)
			if next_product == 0:
				timer_warmup = 20
			if next_product == 1:
				timer_warmup = 40
			if next_product == 2:
				timer_warmup = 60
			if next_product == 3:
				timer_warmup = 240
			if next_product == 4:
				timer_warmup = 300

		timer_warmup -= 1

		if timer_warmup == 0:
			get_node("wall/Particles2D").set_emitting(false)
			
			var enemy = enemies[next_product].instance()
			enemy.set_pos(get_pos())
			enemy.set_rot(get_rot())
			#enemy.get_node("Label").set_text(str(enemy_countdown))
			get_node("/root/Node").add_child(enemy)
			#enemy_countdown -= 1
			
			if next_product == 0:
				points -= 50

			if next_product == 1:
				points -= 90

			if next_product == 2:
				points -= 150

			if next_product == 3:
				points -= 450
				
			if next_product == 4:
				points -= 600

	if points <= 0:
		wave_count += 1
		timer_wave = 900
		if wave_count%5 == 0 and max_level < 5:
			max_level += 1
		points = 80 + wave_count * 20
	timer_wave -= 1


