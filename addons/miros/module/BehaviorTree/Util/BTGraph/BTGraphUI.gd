tool
extends Control

onready var context = $Context
onready var menu = $Menu

func _ready():
	context.visible = false
	

#func _input(event):
#	if event.is_pressed(): 
#		if event.button_index == BUTTON_RIGHT:
#			show_context(event)
#		elif event.button_index == BUTTON_MIDDLE:
#			pass
			
func show_context(event):
	context.rect_global_position = event.position
	context.visible = !context.visible





