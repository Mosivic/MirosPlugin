#############################################################################
#                       Task Serial 顺序任务
#############################################################################
# - author: Mosiv
# - datetime: 2023-10-28 23.51 
# - version: 4.1.1 - 4.1.2 spine editon
# - introduction:
# 	同时执行所有jobs,但所有jobs执行成功时Task执行成功,存在一个以上job执行失败则Task执行
#	失败
#	不考虑job的执行条件
#############################################################################

extends GPCTask
class_name GPCTaskAll


func enter():
	_state = GPC.GoalState.RUNNING
	for job in _jobs:
		job.enter()
	_enter()


func exit():
	for job in _jobs:
		job.exit()
	_exit()


func _execute_job(delta:float,is_physics:bool):
	for job in _jobs:
		job.execute(delta,is_physics)



# 存在一个以上Job失败则Task执行失败
func _is_failed()->bool:
	var is_failed = false
	for job in _jobs:
		if job.get_state() == GPC.JobState.FAILED:
			is_failed = true

	return is_failed


# 所有Job执行成功则Task执行成功
func _is_succeed()->bool:
	var is_succeed = true
	for job in _jobs:
		if  job.get_state() != GPC.JobState.SUCCEED:
			is_succeed = false

	return is_succeed



