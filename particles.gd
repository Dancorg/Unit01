
extends Particles2D

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	set_process(true)
	
func _process(delta):
	if not is_emitting():
		queue_free()


