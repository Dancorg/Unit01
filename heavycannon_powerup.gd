
extends StaticBody2D

var hp = 500
var spark = preload("res://powerup_spark.scn")

func _ready():
	set_process(true)
	pass
	
func _process(delta):

	if hp<=0:
		var blast = spark.instance()
		blast.set_pos(get_pos())
		blast.set_emitting(true)
		get_node("/root/Node").add_child(blast)
		queue_free()


