extends GPCJob
class_name GPCTask


func execute(delta:float,is_physics:bool,st:Dictionary,ds:GPCPropertySensor):
	if not is_physics:
		_update_state(st,ds)
		
	_update_job(st,ds)
	_execute_job(delta,is_physics,st,ds)


func _execute_job(delta:float,is_physics:bool,st:Dictionary,ds:GPCPropertySensor):
	pass


func _update_job(st:Dictionary,ds:GPCPropertySensor):
	pass



