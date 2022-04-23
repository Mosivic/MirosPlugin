extends "res://addons/miros/module/BehaviorTree/Node/BTNode.gd"

func _task():
	return SUCCEED if condition() else FAILED
	
func condition()->bool:
	return true
