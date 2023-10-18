extends Node
class_name GPCAction


var _cost := 1000
var _conditions := {}

var _succeed_effects := {}
var _failed_effects := {}

var _default_perform_state := STATE.ACTION_STATE.SUCCEED

var _enter:Callable = func():return
var _perform:Callable = func():return _default_perform_state
var _perform_physics:Callable = func():return _default_perform_state
var _exit:Callable = func():return
var _is_valid:Callable = func():return true

var _action_name := ""
var state := 0
var midle_states := [0,0]
var _layer := 'default'
var _priority := 1


func _init(action_name:String,layer:String= 'default',priority:int=1,conditions:Dictionary={},succeed_effects:Dictionary={},faild_effects:Dictionary={},cost:int=1000):
	self._cost = cost
	self._succeed_effects = succeed_effects
	self._failed_effects = faild_effects
	self._conditions = conditions
	self._layer = layer
	self._priority = priority
	self._action_name = action_name
	
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


func set_perform_func(t:Callable):
	_perform = t


func set_perform_physics_func(t:Callable):
	_perform_physics = t


func set_default_perform_state(s:int):
	_default_perform_state = s


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
		midle_states[1] = s
	else:
		midle_states[0] = s


func get_state()->int:
	if midle_states[0] == STATE.ACTION_STATE.SUCCEED and midle_states[1] == STATE.ACTION_STATE.SUCCEED:
		return STATE.ACTION_STATE.SUCCEED
	elif midle_states[0] == STATE.ACTION_STATE.FAILED or midle_states[1] == STATE.ACTION_STATE.FAILED:
		return STATE.ACTION_STATE.FAILED
	else:
		return STATE.ACTION_STATE.RUNNING
