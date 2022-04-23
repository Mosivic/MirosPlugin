extends "res://addons/miros/module/BehaviorTree/BTNode.gd"

var result

func _task():
	result = get_child(0)._task()
	if result == SUCCEED:return FAILED
	elif result == FAILED:return SUCCEED
	else:return RUNNING
