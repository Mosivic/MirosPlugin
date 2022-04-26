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
	return task_state

# 任务完成后处理
static func _wrap(e:BTEngine,result:int)->int:
	var current_node_data = e.current_node_data
	var decorators = current_node_data["decorators"]
	var decorator_count = decorators.size()
	if decorator_count == 0:
		return result
	var task_state = e.TASK_STATE.NULL
	var is_succeed = true
	var is_failed  = true
	for key in decorators.keys():
		task_state = e.get_decorator_script(key)._decorate(e,decorators[key],result)
		if task_state == e.TASK_STATE.SUCCEED:
			is_succeed = true
			continue
		elif task_state == e.TASK_STATE.FAILED:
			is_failed = true
			break
		else:
			is_succeed = false
			is_failed = false
			break
	if is_succeed:
		task_state == e.TASK_STATE.SUCCEED
	elif is_failed:
		task_state == e.TASK_STATE.FAILED
	else:
		task_state == e.TASK_STATE.RUNNING
	return task_state

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
				next_node_name = "back"
		e.TASK_STATE.RUNNING:
			next_node_name = "keep"
	return next_node_name


