extends "res://addons/miros/module/BehaviorTree/Node/BTNode.gd"

var result = FAILED

func _task():
	while task_idx < get_child_count():
		result = get_child(task_idx)._task()
		if result == FAILED:
			task_idx += 1
		else:
			break
	
	if task_idx >= get_child_count() || result == SUCCEED:
		task_idx = 0
	# 如果都没执行成功, 返回FAILED
	return FAILED
