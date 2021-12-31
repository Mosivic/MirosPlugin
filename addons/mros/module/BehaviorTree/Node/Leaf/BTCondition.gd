extends "BTLeafBase.gd"

func _task():
	return SUCCEED if condition() else FAILED
	
func condition()->bool:
	return true
