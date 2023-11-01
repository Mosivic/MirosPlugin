#############################################################################
#                       Task Serial 顺序任务
#############################################################################
# - author: Mosiv
# - datetime: 2023-10-28 
# - version: 4.1.1 - 4.1.2 spine editon
# - introduction:
# 	依次执行设置的jobs, 当所有jobs都执行成功时则Task执行成功,否则Task执行失败
#	不考虑job的执行条件
#############################################################################

extends GPCTask
class_name GPCTaskSerial



func enter(st:Dictionary,ds:GPCPropertySensor):
	GPCJobsSetting.set_job_state(st,GPC.JobState.RUNNING)
	GPCJobsSetting.set_task_current_job_index(st,0)
	GPCJobsSetting.get_task_current_job(st).enter(GPCJobsSetting.get_task_current_job_data(st),ds)
	
	_enter(st,ds)


func exit(st:Dictionary,ds:GPCPropertySensor):
	GPCJobsSetting.get_task_current_job(st).exit(st,ds)

	_exit(st,ds)


func _execute_job(delta:float,is_physics:bool,st:Dictionary,ds:GPCPropertySensor):
	var current_job_data = GPCJobsSetting.get_task_current_job_data(st)
	GPCJobsSetting.get_job(current_job_data).execute(delta,is_physics,current_job_data,ds)



func _update_job(st:Dictionary,ds:GPCPropertySensor):
	
	var index = GPCJobsSetting.get_task_current_job_index(st)
	var size = GPCJobsSetting.get_task_jobs_size(st)
	
	if index < size -1 and GPCJobsSetting.get_task_current_job_state(st) == GPC.JobState.SUCCEED:
		GPCJobsSetting.get_task_current_job(st).exit(GPCJobsSetting.get_task_current_job_data(st),ds)
		GPCJobsSetting.set_task_current_job_index(st,index + 1)
		GPCJobsSetting.get_task_current_job(st).enter(GPCJobsSetting.get_task_current_job_data(st),ds)
		
	elif index == size -1 and GPCJobsSetting.get_task_current_job_state(st) == GPC.JobState.SUCCEED:
		GPCJobsSetting.get_task_current_job(st).exit(GPCJobsSetting.get_task_current_job_data(st),ds)



# 重写该方法,自定义执行失败的条件
func _is_failed(st:Dictionary,ds:GPCPropertySensor)->bool:
	var is_failed = false
	if  GPCJobsSetting.get_task_current_job_state(st) == GPC.JobState.FAILED:
		is_failed = true

	return is_failed


# 重写该方法,自定义执行成功的条件
func _is_succeed(st:Dictionary,ds:GPCPropertySensor)->bool:
	var is_succeed = false
	var index = GPCJobsSetting.get_task_current_job_index(st)
	var size = GPCJobsSetting.get_task_jobs_size(st)

	if index == size - 1 and GPCJobsSetting.get_task_current_job_state(st) == GPC.JobState.SUCCEED:
		is_succeed = true
	
	return is_succeed



