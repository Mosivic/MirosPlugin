extends "BTCompositeBase.gd"

# 串行执行子结点行为
# 只有子结点任务全部成功或全部失败时，返回任务结果
static func _task(e:BTEngine,is_physics:bool,delta:float)->int:
	var node_data = e.current_node_data

	var children_node = node_data["children_node"]
	var children_count = children_node.size()
	if children_count == 0:
		return STATE.TASK_STATE.FAILED
	
	var actions:Array
	var states:Array
	for child_node_name in children_node:
		var action = e.Get_node_data_by_name(child_node_name)["action"]
		actions.append(actions)
	states = sequence_actions_execute(actions,is_physics,delta)
	
	return _wrap(node_data,states)



