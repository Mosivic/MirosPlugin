#############################################################################
#                       Task Select 选择任务
#############################################################################
# - author: Mosiv
# - datetime: 2023-10-29 23.37 
# - version: 4.1.1 - 4.1.2 spine editon
# - introduction:
# 	从设置的jobs中选择满足执行条件且优先级最高的单个job执行
#	考虑job的执行条件
#############################################################################

extends GPCTask
class_name GPCTaskSelect

var _selected_job:GPCJob

func enter():
	_state = GPC.GoalState.RUNNING
	_selected_job = null
	_enter()


func exit():
	if _selected_job != null:
		_selected_job.exit()
	_exit()


func _execute_job(delta:float,is_physics:bool):
	if _selected_job != null:
		_selected_job.execute(delta,is_physics)


func _update_job():
	if _selected_job != null : return
	
	var candicate_jobs = []
	
	for job in _jobs:
		if job.can_execute():
			candicate_jobs.append(job)
			_selected_job = job
			
			
	if candicate_jobs.size() != 0:
		_selected_job = _get_higest_priorty_job(candicate_jobs)
		_selected_job.enter()


# 重写该方法,自定义执行失败的条件
func _is_failed()->bool:
	if _selected_job != null:
		return _selected_job._is_failed()
	else:
		return false 


# 重写该方法,自定义执行成功的条件
func _is_succeed()->bool:
	if _selected_job != null:
		return _selected_job._is_failed()
	else:
		return false 


# 获取最合适的Job
# 参数jobs不能为空
func _get_higest_priorty_job(jobs:Array):
	var best_job = jobs[0]
	for  job in jobs:
		if _property_sensor.get_jobs_setting().get_job_layer(job.name) >= _property_sensor.get_jobs_setting().get_job_layer(best_job.name):
			best_job = job
	
	return best_job

