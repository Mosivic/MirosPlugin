extends "BTCompositeBase.gd"


# 并行执行子结点行为
# 只有子结点任务全部成功或全部失败时，返回任务结果
static func _task(e:BTEngine,is_physics:bool,delta)->int:
	var node_name = e.current_node_name
	var children_node = e.current_node_data["children_node"]
	var children_count = children_node.size()
	if children_count == 0:
		return e.TASK_STATE.FAILED
	
	var actions:Array
	for child_node_name in children_node:
		actions.append(e.graph_data[child_node_name]["action"])
	parallel_action_execute(actions,is_physics,delta)
	
	var task_state
	if is_actions_all_succeed(actions):
		task_state = e.TASK_STATE.SUCCEED
	elif is_actions_all_failed(actions):
		task_state = e.TASK_STATE.FAILED
	else:
		task_state = e.TASK_STATE.RUNNING
	return _wrap(e,task_state)

