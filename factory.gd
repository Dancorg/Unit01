
extends Node2D

#var hp=50000

var wave_count = 0
#var timer_wave = 120
var timer_warmup = -1
var points = 150

var next_product = 0

var enemies = [preload("res://eneimgo.scn"), preload("res://enemigo2.scn"),preload("res://enemigo3.scn"),preload("res://enemigo4.scn")]

export(int) var timer_wave=120

func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	if timer_wave <= 0:
		if timer_warmup == -1:
			next_product = floor(rand_range(0,4))
			get_node("wall/Particles2D").set_emitting(true)
			if next_product == 0:
				timer_warmup = 30
			if next_product == 1:
				timer_warmup = 60
			if next_product == 2:
				timer_warmup = 240
			if next_product == 3:
				timer_warmup = 300

		timer_warmup -= 1

		if timer_warmup == 0:
			get_node("wall/Particles2D").set_emitting(false)
			if next_product == 0:
				points -= 100
				var enemy = enemies[0].instance()
				enemy.set_pos(get_pos())
				#enemy.get_node("Label").set_text(str(enemy_countdown))
				get_node("/root/Node").add_child(enemy)
				#enemy_countdown -= 1
			if next_product == 1:
				points -= 200
				var enemy = enemies[1].instance()
				enemy.set_pos(get_pos())
				#enemy.get_node("Label").set_text(str(enemy_countdown))
				get_node("/root/Node").add_child(enemy)
				#enemy_countdown -= 1
			if next_product == 2:
				points -= 400
				var enemy = enemies[2].instance()
				enemy.set_pos(get_pos())
				#enemy.get_node("Label").set_text(str(enemy_countdown))
				get_node("/root/Node").add_child(enemy)
				#enemy_countdown -= 1
			if next_product == 3:
				points -= 500
				var enemy = enemies[3].instance()
				enemy.set_pos(get_pos())
				#enemy.get_node("Label").set_text(str(enemy_countdown))
				get_node("/root/Node").add_child(enemy)
				#enemy_countdown -= 1
	if points <= 0:
		timer_wave = 600
		points = 150 + wave_count * 20
	timer_wave -= 1


