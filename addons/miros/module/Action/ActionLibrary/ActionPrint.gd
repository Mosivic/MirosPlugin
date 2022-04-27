extends "res://addons/miros/module/Action/ActionBase.gd"



func _init(name:String="ActionPrint",live_time:float=1,type=1,args:Dictionary={}).(name,live_time,type,args):
	pass
	
	
func _action_process():
	print("Hello ")

func _action_physics_process():
	print("NiMamadi")
