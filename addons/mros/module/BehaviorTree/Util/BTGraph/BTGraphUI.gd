tool
extends Control

onready var context = $UI/Context
onready var menu = $UI/Menu

func _input(event):
	if event.is_pressed(): 
		if event.button_index == BUTTON_RIGHT:
			show_context(event)
		elif event.button_index == BUTTON_MIDDLE:
			hide_context()
			
func show_context(event):
	context.rect_global_position = event.position
	context.show()

func hide_context():
	context.hide()

