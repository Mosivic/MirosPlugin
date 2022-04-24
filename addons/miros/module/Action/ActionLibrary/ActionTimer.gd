###
# 暂时器Action  By Mosiv 2022.04.23
# 需要传入参数time，指定暂停时间
###
extends "res://addons/miros/module/Action/ActionBase.gd"


func _init(name:String="ActionTimer",live_time:float=-1,type=2,args:Dictionary={}).(name,live_time,type,args):
	pass
	

func _over_condition()->bool:
	if currentTime >= actionArgs["time"]:
		print("Timer:had run time: "+ str(currentTime))
		return true
	return false
