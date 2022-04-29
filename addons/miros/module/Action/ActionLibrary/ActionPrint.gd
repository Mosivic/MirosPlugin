extends "res://addons/miros/module/Action/ActionBase.gd"



func _init(name:String="ActionPrint",live_time:float=1,type=1).(name,live_time,type):
	pass
	
	
func _action_process(delta):
	print("Hello ")

func _action_physics_process(delta):
	print("NiMamadi")
