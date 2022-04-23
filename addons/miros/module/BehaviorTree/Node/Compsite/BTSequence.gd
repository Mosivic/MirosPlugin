extends "res://addons/miros/module/BehaviorTree/Node/BTNode.gd"

var result = SUCCEED

func _task():
	while task_idx < get_child_count():
		result = get_child(task_idx)._task()
		if result == SUCCEED:
			task_idx += 1
		else:
			break
	# 组合执行完成或中断
	if task_idx >= get_child_count() || result == FAILED:
		task_idx = 0
	# 如果都执行成功, 返回SUCCESSED
	return SUCCEED
