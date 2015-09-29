
extends Control

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	set_process(true)


func _on_ToolButton_pressed():
	get_tree().change_scene("res://main.scn")

func _process(delta):
	if Input.is_action_pressed("open_menu"):
		get_tree().quit()