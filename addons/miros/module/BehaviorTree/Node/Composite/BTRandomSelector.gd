extends "BTCompositeBase.gd"


# 随机执行子结点行为
# 将随机数字保存在action_args中，行为执行成功或失败后擦除该数据
static func _task(e:BTEngine,action_func_type:int,delta)->int:
	var node_data = e.current_node_data
	var children_node = node_data["children_node"]
	var children_count = children_node.size()
	if children_count == 0:
		return e.TASK_STATE.FAILED
	randomize()
	var random_index = randi() % children_count
	if !e.action_args.has("random_temp"):
		e.action_args["random_temp"] = random_index
	var action = e.graph_data[children_node[random_index]]["action"]
	var action_state = aciton_execute(e,action,action_func_type,delta)
	var task_state
	match action_state:
		e.ACTION_STATE.NULL:
			task_state = e.TASK_STATE.NULL
		e.ACTION_STATE.PREPARE:
			task_state = e.TASK_STATE.RUNNING
		e.ACTION_STATE.SUCCEED:
			e.action_args.erase("random_temp")
			task_state = e.TASK_STATE.SUCCEED
		e.ACTION_STATE.FAILED:
			e.action_args.erase("random_temp")
			task_state = e.TASK_STATE.FAILED
	return task_state
