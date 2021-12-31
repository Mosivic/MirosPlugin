extends "res://addons/mros/module/BehaviorTree/BTNode.gd"

var blackboard = null

func set_blackboard(value):
	blackboard = value
	
func set_data(property:String,value):
	blackboard.data[property] = value

func get_data(property:String):
	return blackboard.data[property]
	
func _task():
	return SUCCEED
