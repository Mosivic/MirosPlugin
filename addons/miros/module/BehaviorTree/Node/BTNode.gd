extends Node
class_name BTNodeBase



# 节点任务
static func _task(e:BTEngine,is_physics:bool,delta:float)->int:
	var task_state
	var action = e.current_node_data["action"]
	var action_state = action_execute(action,is_physics,delta)
	match action_state:
		e.ACTION_STATE.SUCCEED:
			task_state = e.TASK_STATE.SUCCEED
		e.ACTION_STATE.FAILED:
			task_state = e.TASK_STATE.FAILED
		e.ACTION_STATE.RUNNING:
			task_state = e.TASK_STATE.RUNNING
		e.ACTION_STATE.NULL:
			task_state = e.TASK_STATE.NULL
	return _wrap(e,task_state)


# 任务完成后处理
static func _wrap(e:BTEngine,result:int)->int:
	var current_node_data = e.current_node_data
	var decorators = current_node_data["decorators"]
	var decorator_count = decorators.size()
	if decorator_count == 0:
		return result

	for key in decorators.keys():
		result = e.get_decorator_script(key)._decorate(e,decorators[key],result)

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
				next_node_name = "back"
		e.TASK_STATE.RUNNING:
			next_node_name = "keep"
	return next_node_name

# 行为执行
static func action_execute(action:ActionBase,is_physics:bool,delta:float)->int:
	var action_state = action.Get_state()
	match action_state:
		action.ACTION_STATE.NULL:
			if action.Is_can_execute(): # 可以开始
				action.Execute_before()
				action_state = action.ACTION_STATE.RUNNING
			else:
				action_state = action.ACTION_STATE.FAILED
		action.ACTION_STATE.RUNNING:
			if action.Is_continue_execute(): # 可以继续
				action.Execute(delta,is_physics)
				if action.Is_over_execute(): # 可以结束
					action.Execute_after()
					action_state = action.ACTION_STATE.SUCCEED
				else:
					action_state = action.ACTION_STATE.RUNNING
		action.ACTION_STATE.SUCCEED:
			pass
		action.ACTION_STATE.FAILED:
			pass
	action.Set_state(action_state)
	return action_state

# 行为集顺序执行
static func sequence_action_execute(actions:Array,is_physics:bool,delta:float):
	var action_state
	for action in actions:
		action_state = action_execute(action,is_physics,delta)
		if action_state == action.ACTION_STATE.SUCCEED or action_state == action.ACTION_STATE.FAILED:
			continue
		else:
			break

# 行为集并行执行
static func parallel_action_execute(actions:Array,is_physics:bool,delta:float):
	for action in actions:
		action_execute(action,is_physics,delta)

static func is_actions_all_over(actions:Array)->bool:
	var action_state
	for action in actions:
		action_state = action.Get_state()
		if action_state == action.ACTION_STATE.NULL or action_state == action.ACTION_STATE.RUNNING:
			return false
	return true

static func is_actions_all_succeed(actions:Array)->bool:
	var action_state
	for action in actions:
		action_state = action.Get_state()
		if action_state != action.ACTION_STATE.SUCCEED:
			return false
	return true

static func is_actions_all_failed(actions:Array)->bool:
	var action_state
	for action in actions:
		action_state = action.Get_state()
		if action_state != action.ACTION_STATE.FAILED:
			return false
	return true

static func is_actions_has_failed(actions:Array)->bool:
	var action_state
	for action in actions:
		action_state = action.Get_state()
		if action_state == action.ACTION_STATE.FAILED:
			return true
	return false
	
static func is_actions_has_succeed(actions:Array)->bool:
	var action_state
	for action in actions:
		action_state = action.Get_state()
		if action_state == action.ACTION_STATE.SUCCEED:
			return true
	return false
