extends "res://addons/miros/module/Action/ActionBase.gd"

var actor:Node

# 无限生命时长，循环


func _action_process(delta):
	pass

func _action_physics_process(delta):
	pass


func _start_condition()->bool:
	return true
	
func _over_condition()->bool:
	return true
