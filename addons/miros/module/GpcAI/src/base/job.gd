# Job
# job在execute函数执行过程中,自身会更新state值,且当执行成功或失败时会自动应用其effects
# 1: execute can_execute 
# 2: get_state get_cost get_priorty get_layer()...
extends WeakRef
class_name GPCJob

#
#var ds:GPCPropertySensor


func _enter(st:Dictionary,ds:GPCPropertySensor):
	return 


func _running(delta,st:Dictionary,ds:GPCPropertySensor):
	return


func _running_physics(delta,st:Dictionary,ds:GPCPropertySensor):
	return


func _exit(st:Dictionary,ds:GPCPropertySensor):
	return


func _succeed():
	return


func _failed():
	return


#func get_actor():
#	return ds.get_actor()


#func set_property_sensor(p):
#	ds = p


# 返回是否满足开始执行条件
func can_execute(st:Dictionary,ds:GPCPropertySensor) -> bool:
	var can_execute = true
	var preconditions = GPCJobsSetting.get_job_preconditions(st)
	
	for key in preconditions.keys():
		if key is String: 
			if ds.get(key) is bool:
				if ds.get(key) != preconditions[key]:
					can_execute = false
					break
			elif ds.get(key) is Callable:
				if not ds.get(key).call():
					can_execute = false
					break
		elif key is Callable:
			if not key.call():
				can_execute = false
				break

	return can_execute


# 是否继续执行
func _update_state(st:Dictionary,ds:GPCPropertySensor):
	var state = GPCJobsSetting.get_job_state(st)
	
	if _is_failed(st,ds):
		state = GPC.JobState.FAILED
		ds.apply_effects(GPCJobsSetting.get_job_failed_effects(st))
	elif _is_succeed(st,ds):
		state = GPC.JobState.SUCCEED
		ds.apply_effects(GPCJobsSetting.get_job_succeed_effects(st))
	else :
		state = GPC.JobState.RUNNING
		
	GPCJobsSetting.set_job_state(st,state)
	

# 重写该方法,自定义执行失败的条件
func _is_failed(st:Dictionary,ds:GPCPropertySensor)->bool:
	return ds.any_conditions_satisfy(GPCJobsSetting.get_job_failed_conditions(st))



# 重写该方法,自定义执行成功的条件
func _is_succeed(st:Dictionary,ds:GPCPropertySensor)->bool:
	return ds.all_conditions_satisfy(GPCJobsSetting.get_job_succeed_conditions(st))


func _execute(delta:float,is_physics:bool,st:Dictionary,ds:GPCPropertySensor):
	if is_physics:
		_running_physics(delta,st,ds)
	else:
		_running(delta,st,ds)


func enter(st:Dictionary,ds:GPCPropertySensor):
	GPCJobsSetting.set_job_state(st,GPC.JobState.RUNNING)
	_enter(st,ds)
	

func exit(st:Dictionary,ds:GPCPropertySensor):
	_exit(st,ds)


func execute(delta:float,is_physics:bool,st:Dictionary,ds:GPCPropertySensor):
	if not is_physics:
		_update_state(st,ds)
	
	_execute(delta,is_physics,st,ds)








