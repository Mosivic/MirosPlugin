extends "res://addons/miros/module/BehaviorTree/BTNode.gd"

enum RunType{
	NULL,
	TaskCount, # 任务次数执行(多帧)
	LoopCount, # 单帧次数循环
}

export(RunType) var run_type = RunType.TaskCount
export var max_count = 3 # 最大执行次数

var run_func:FuncRef
var count = 0 # 当前执行次数

func _task():
	return run_func.call_func()
	
func _run_loop():
	count = 0
	while count < max_count:
		count += 1
		if get_child(0)._task() == FAILED:
			return FAILED
	return SUCCEED

func _run_task():
	var result = get_child(0)._task()
	count += 1
	if result == FAILED:
		count = 0
		return FAILED
	if count < max_count:
		return RUNNING
	else:
		count = 0
		return SUCCEED
