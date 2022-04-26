extends "BTDecoratorBase.gd"

# 循环执行多次
static func _decorate(e:BTEngine,arg:int,result:int)->int:
	if !e.action_args.has("loop_succeed_count"):
		e.action_args["loop_succeed_count"] = 0
	match result:
		e.TASK_STATE.NULL:
			pass
		e.TASK_STATE.SUCCEED:
			e.action_args["loop_succeed_count"] += 1
			e.current_node_action.reset()
			result = e.TASK_STATE.RUNNING
		e.TASK_STATE.FAILED:
			return result  #执行失败，直接退出返回失败
		e.TASK_STATE.RUNNING:
			pass
	if e.action_args["loop_succeed_count"] >= arg:
		result = e.TASK_STATE.SUCCEED
		e.action_args.erase("loop_succeed_count")
	else:
		result = e.TASK_STATE.RUNNING
	return result
	
