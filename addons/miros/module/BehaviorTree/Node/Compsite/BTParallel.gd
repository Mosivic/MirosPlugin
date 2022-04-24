extends "BTCompsiteBase.gd"

# 节点任务
static func _task(e:BTEngine)->int:
	var node_name = e.current_node_name
	var right_nodes_name = e.current_node_data["right_nodes_name"]
	var is_ok = true
	for right_node_name in right_nodes_name:
		var action = e.graph_data[right_node_name]["action"]
		var action_state = action.execute(e.get_process_delta_time())
		if !action_state == e.ACTION_STATE.SUCCEED:
			is_ok = false 

	var task_state 
	if is_ok:
		task_state = e.TASK_STATE.SUCCEED
	else:
		task_state = e.TASK_STATE.FAILED
	return _wrap(e,task_state)


static func _next(e:BTEngine,result:int)->String:
	var r:String
	match result:
		e.TASK_STATE.NULL:
			r =  "keep"
		e.TASK_STATE.SUCCEED:
			for right_node_name in e.current_node_data["right_nodes_name"]:
				if !e.graph_data[right_node_name]["right_nodes_name"].size() == 0:
					r = e.graph_data[right_node_name]["right_nodes_name"]
		e.TASK_STATE.FAILED:
			r = "back"
	return r

