extends "BTLeafBase.gd"

func _task():
	return action(get_viewport().get_physics_process_delta_time())
	
func action(delta:float)->int:
	return SUCCEED
