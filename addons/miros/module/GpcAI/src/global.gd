extends WeakRef
class_name  GPC


const JobState = {
	RUNNING = 0, # 运行中
	SUCCEED = 1, # 成功
	FAILED = 2, # 失败 
}



const TaskMode = {
	SERIAL = 0, # 串行
	SERIAL_PRIORITY = 7, # 串行 优先级原则
	PARALLEL_ANY = 1, # 并行 全部执行成功
	PARALLEL_ALL = 2, # 并行 单个执行成功
	SELECTOR_RANDOM = 3, # 选择 随机原则
	SELECTOR_WEIGHT = 4, # 选择 权重原则
	SELECTOR_PRIORITY = 5, # 选择 优先级原则
	SELECTOR_CONDITION = 6 # 选择 条件原则
}


const GoalState = {
	RUNNING = 0, # 运行中
	SUCCEED = 1, # 成功
	FAILED = 2, # 失败 
}


const JobType = {
	ACTION = 0,
	TASK_SERIAL = 1,
	TASK_SELECT = 2,
	TASK_ALL = 3,
}


