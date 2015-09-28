
extends Node2D

var wave_count = 0
var time_to_wave = 120
var enemy_countdown = 1000

var enemies = [preload("res://eneimgo.scn"), preload("res://enemigo2.scn"),preload("res://enemigo3.scn"),preload("res://enemigo4.scn")]

func _ready():
	set_process(true)

func _process(delta):

	time_to_wave -= 1
	if time_to_wave == 0:
		time_to_wave = 600
		wave_count += 1
		var points = 150 + wave_count * 50
		while points > 100:
			var type = floor(rand_range(0,4))
			var side = floor(rand_range(0,4))
			var position
			var viewport = get_viewport_rect().size
			if side == 0:
				position = Vector2(rand_range(-100, viewport[0]+100), -100)
			if side == 1:
				position = Vector2(rand_range(-100, viewport[0]+100), viewport[1]+100)
			if side == 2:
				position = Vector2(-100, rand_range(-100, viewport[1]+100))
			if side == 3:
				position = Vector2(viewport[0]+100, rand_range(-100, viewport[1]+100))
			if type == 0:
				points -= 100
				var enemy = enemies[0].instance()
				enemy.set_pos(position)
				enemy.get_node("Label").set_text(str(enemy_countdown))
				get_node("/root/Node").add_child(enemy)
				enemy_countdown -= 1
			if type == 1 and wave_count > 3:
				points -= 200
				var enemy = enemies[1].instance()
				enemy.set_pos(position)
				enemy.get_node("Label").set_text(str(enemy_countdown))
				get_node("/root/Node").add_child(enemy)
				enemy_countdown -= 1
			if type == 2 and wave_count > 10:
				points -= 400
				var enemy = enemies[2].instance()
				enemy.set_pos(position)
				enemy.get_node("Label").set_text(str(enemy_countdown))
				get_node("/root/Node").add_child(enemy)
				enemy_countdown -= 1
			if type == 3 and wave_count > 15:
				points -= 500
				var enemy = enemies[3].instance()
				enemy.set_pos(position)
				enemy.get_node("Label").set_text(str(enemy_countdown))
				get_node("/root/Node").add_child(enemy)
				enemy_countdown -= 1
