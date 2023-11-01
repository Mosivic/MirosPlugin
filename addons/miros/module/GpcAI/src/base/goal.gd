extends WeakRef
class_name GPCGoal

var name = ""

var _property_sensor:GPCPropertySensor

var _state = GPC.GoalState.SUCCEED

var _jobs:Array = []

var _current_job_index := 0

func set_property_sensor(p):
	_property_sensor = p


func get_state():
	return _state


# 返回是否满足开始执行条件
func can_execute() -> bool:
	var can_execute = true
	var preconditions = _property_sensor.get_jobs_setting().get_job_preconditions(name)

	for key in preconditions.keys():
		if key is String: 
			if _property_sensor.get(key) is bool:
				if _property_sensor.get(key) != preconditions[key]:
					can_execute = false
					break
			elif _property_sensor.get(key) is Callable:
				if not _property_sensor.get(key).call():
					can_execute = false
					break
		elif key is Callable:
			if not key.call():
				can_execute = false
				break

	return can_execute


func enter(jobs):
	_jobs = jobs
	_state = GPC.GoalState.RUNNING
	_current_job_index = 0
	_jobs[_current_job_index].enter()


func exit():
	_jobs[_current_job_index].exit() 


func execute(delta:float,is_phyiscs:bool):
	if not is_phyiscs:
		_update_state()
	
	_update_job()
	_jobs[_current_job_index].execute(delta,is_phyiscs)


func _update_state():
	if _is_failed():
		_state = GPC.GoalState.FAILED
	elif _is_succeed():
		_state = GPC.GoalState.SUCCEED
	else :
		_state = GPC.GoalState.RUNNING


func _update_job():
	var job_state = _jobs[_current_job_index].get_state()
	if _current_job_index < _jobs.size() - 1:
		if job_state == GPC.JobState.SUCCEED: 
			_jobs[_current_job_index].exit()
			_current_job_index += 1
			_jobs[_current_job_index].enter()
	elif _current_job_index == _jobs.size() - 1:
		if job_state != GPC.JobState.RUNNING:
			_jobs[_current_job_index].exit()
	


func _is_succeed()->bool:
	return _current_job_index == _jobs.size() - 1 and _jobs[_current_job_index].get_state() == GPC.JobState.SUCCEED


func _is_failed()->bool:
	return _jobs[_current_job_index].get_state() == GPC.JobState.FAILED
	


