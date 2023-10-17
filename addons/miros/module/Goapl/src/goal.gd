#
# Goal contract
#
extends Node
class_name GoaplGoal

var _priority := 1
var _desire_state := {}
var _is_valid:Callable

func _init(priorty:int,desired_state:Dictionary,is_valid:Callable=func():return true):
	_priority = priorty
	_desire_state = desired_state
	_is_valid = is_valid
	
func is_valid() -> bool:
	return _is_valid.call()


func get_priority() -> int:
	return _priority


func get_desired_state() -> Dictionary:
	return _desire_state
