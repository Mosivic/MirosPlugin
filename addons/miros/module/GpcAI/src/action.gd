extends Node
class_name GPCAction

var _layer := 'default'
var _priority := 1
var _cost := 10

var _conditions := {}
var _succeed_effects := {}
var _failed_effects := {}

var _enter:Callable = func():return
var _exit:Callable = func():return
var _perform:Callable = func():return _default_perform_state
var _perform_physics:Callable = func():return _default_perform_state
var _succeed:Callable = func():return
var _failed:Callable = func():return
var _is_valid:Callable = func():return true

var _middle_state := [0,0]
var _default_perform_state := STATE.ACTION_STATE.SUCCEED

var property_sensor:GPCPropertySensor

func init():
	pass


func is_valid() -> bool:
	return _is_valid.call()


func enter():
	return _enter.call()


func perform(delta) -> int:
	return _perform.call()


func perform_physics(delta) ->int:
	return _perform_physics.call()


func exit():
	return _exit.call()


func succeed():
	return _succeed.call()


func failed():
	return _failed.call()

func set_perform_func(t:Callable):
	_perform = t


func set_perform_physics_func(t:Callable):
	_perform_physics = t


func set_default_perform_state(s:int):
	_default_perform_state = s


func set_property_sensor(p):
	property_sensor = p


func get_conditions():
	return _conditions


func get_cost():
	return _cost


func get_priority():
	return _priority


func get_layer():
	return _layer


func get_succeed_effects():
	return _succeed_effects


func get_failed_effects():
	return _failed_effects


func set_single_midle_state(s:int,is_physics:bool):
	if is_physics:
		_middle_state[1] = s
	else:
		_middle_state[0] = s


func get_state()->int:
	if _middle_state[0] == STATE.ACTION_STATE.SUCCEED and _middle_state[1] == STATE.ACTION_STATE.SUCCEED:
		return STATE.ACTION_STATE.SUCCEED
	elif _middle_state[0] == STATE.ACTION_STATE.FAILED or _middle_state[1] == STATE.ACTION_STATE.FAILED:
		return STATE.ACTION_STATE.FAILED
	else:
		return STATE.ACTION_STATE.RUNNING
