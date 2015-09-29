
extends PopupPanel

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	var control_style = get_node("ControlStyle")
	control_style.add_item("Absolute")
	control_style.add_item("Relative")
	pass


func _on_BackToGame_pressed():
	get_tree().set_pause(false)
	hide()


func _on_QuitToMenu_pressed():
	get_tree().set_pause(false)
	hide()
	get_tree().change_scene("res://splash_screen.scn")


func _on_ControlStyle_item_selected( ID ):
	var player = get_node("/root/Node/ship_blue")
	player.direction_mode = ID
