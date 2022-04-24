extends Node
class_name BTNodeBase


# 节点任务
static func _task(e:BTEngine)->int:
	var action = e.current_node_data["action"]
	var delta = e.get_process_delta_time()
	var action_state = action.execute(delta)
	var task_state 
	match action_state:
		e.ACTION_STATE.NULL:# NULL
			task_state = e.TASK_STATE.NULL
		e.ACTION_STATE.PREPARE:# PREPARE
			pass
		e.ACTION_STATE.RUNNING:# RUNNING
			task_state = e.TASK_STATE.RUNNING
		e.ACTION_STATE.SUCCEED: # SUCCEED,
			task_state = e.TASK_STATE.SUCCEED
		e.ACTION_STATE.FAILED: # FAILED
			task_state = e.TASK_STATE.FAILED
	return _wrap(e,task_state)

# 任务完成后处理
static func _wrap(e,result:int)->int:
	return result

# 取得下个节点
static func _next(e:BTEngine,result:int)->String:
	var next_node_name:String
	var node_data = e.current_node_data
	match result:
		e.TASK_STATE.NULL:
			next_node_name = "keep"
		e.TASK_STATE.SUCCEED:
			# 右结点个数为0时，返回空字符串
			if node_data["right_nodes_name"].size() == 0:
				next_node_name = "over"
			else:
				next_node_name = node_data["right_nodes_name"][0]
		e.TASK_STATE.FAILED:
			# 左结点个数为0时，返回空字符串
			if node_data["left_nodes_name"].size() == 0:
				next_node_name = "over"
			else:
				next_node_name = node_data["left_nodes_name"][0]
		e.TASK_STATE.RUNNING:
			next_node_name = "keep"
	return next_node_name

