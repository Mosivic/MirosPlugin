extends "BTCompositeBase.gd"


# 并行执行子结点行为
# 只有子结点任务全部成功或全部失败时，返回任务结果
static func _task(e:BTEngine)->int:
	var node_name = e.current_node_name
	var children_node = e.current_node_data["children_node"]
	var children_count = children_node.size()
	if children_count == 0:
		return _wrap(e,e.TASK_STATE.FAILED)
	var task_state
	var is_succeed = true
	var is_failed = true
	for child_node_name in children_node:
		var action = e.graph_data[child_node_name]["action"]
		var action_state = action.execute(e.get_process_delta_time())
		if action_state != e.ACTION_STATE.SUCCEED:
			is_succeed = false 
		if action_state == e.ACTION_STATE.SUCCEED:
			is_failed = false
	if is_succeed:
		task_state = e.TASK_STATE.SUCCEED
	elif is_failed:
		task_state = e.TASK_STATE.FAILED
	else:
		task_state = e.TASK_STATE.RUNNING
	return _wrap(e,task_state)

