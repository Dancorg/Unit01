
extends PopupPanel

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	var control_style = get_node("ControlStyle")
	control_style.add_item("Absolute")
	control_style.add_item("Relative")
	pass


func _on_BackToGame_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	get_tree().set_pause(false)
	hide()


func _on_QuitToMenu_pressed():
	get_tree().set_pause(false)
	hide()
	get_tree().change_scene("res://splash_screen.scn")


func _on_ControlStyle_item_selected( ID ):
	var player = get_node("/root/Node/ship_blue")
	player.direction_mode = ID


func _on_Fullscreen_toggled( pressed ):
	if(OS.is_window_fullscreen()):
		OS.set_window_fullscreen(false)
	else:
		OS.set_window_fullscreen(true)
