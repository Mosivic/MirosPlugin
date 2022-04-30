extends "BTCompositeBase.gd"

# 串行执行子结点行为
# 只有子结点任务全部成功或全部失败时，返回任务结果
static func _task(e:BTEngine,is_physics:bool,delta:float)->int:
	var node_name = e.current_node_name
	var children_node = e.current_node_data["children_node"]
	var child_count = children_node.size()
	if child_count == 0:
		return e.TASK_STATE.FAILED
	var task_state
	var action_state
	var is_succeed = true
	var is_failed = true
	for child_node_name in children_node:
		var action = e.graph_data[child_node_name]["action"]
		action_state =  action_execute(e,is_physics,delta)
		if action_state == e.ACTION_STATE.SUCCEED:
			continue
		elif action_state == e.ACTION_STATE.FAILED:
			is_failed = true
			break
		else:
			is_succeed = false
			is_failed  = false
			break
	if is_succeed:
		task_state = e.TASK_STATE.SUCCEED
	elif is_failed:
		task_state = e.TASK_STATE.FAILED
	else:
		task_state = e.TASK_STATE.RUNNING
	return task_state


