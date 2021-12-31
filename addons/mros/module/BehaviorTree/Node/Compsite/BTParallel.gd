extends "res://addons/mros/module/BehaviorTree/BTNode.gd"

var result = SUCCEED

func _task():
	var is_runing = false
	# 运行全部子节点,其一失败返回FAILED
	for task_idx in get_child_count():
		var node = get_child(task_idx)
		result = node._task()
		if result == FAILED:
			return FAILED
		elif result == RUNNING:
			is_runing
		
		if is_runing:return RUNNING
		return SUCCEED
