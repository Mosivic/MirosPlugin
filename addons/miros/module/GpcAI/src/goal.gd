extends Node
class_name GPCGoal

var _priority := 1
var _desire_property := {}
var _is_valid:Callable = func():return true

var _property_sensor:GPCPropertySensor

func init():
	pass
	
func is_valid() -> bool:
	return _is_valid.call()


func set_property_sensor(p):
	_property_sensor = p

func get_priority() -> int:
	return _priority


func get_desired_state() -> Dictionary:
	return _desire_property 

