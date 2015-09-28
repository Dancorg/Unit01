
extends Control

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	pass


func _on_ToolButton_pressed():
	get_tree().change_scene("res://main.scn")
