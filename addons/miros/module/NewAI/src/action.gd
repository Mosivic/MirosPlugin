extends Node
class_name GPCAction

enum RUN_STATE{
	Null,
	Running,
	Successed,
	Failed
	
}

var _cost := 1000
var _preconditions := {}
var _effects := {}



var _enter:Callable = func():return
var _perform:Callable = func():return false
var _perform_physics:Callable = func():return false
var _exit:Callable = func():return
var _is_valid:Callable = func():return true

var run_state = RUN_STATE.Null 


func _init(action_name:String,preconditions:Dictionary={},effects:Dictionary={},cost:int=1000):
	self._cost = cost
	self._effects = effects
	self._preconditions =preconditions
	name = action_name
	
func is_valid() -> bool:
	return _is_valid.call()


func enter():
	return _enter.call()


func perform(delta) -> bool:
	return _perform.call()


func perform_physics(delta) ->bool:
	return _perform_physics.call()


func exit():
	return _exit.call()


func set_perform_func(t:Callable):
	_perform = t

func set_perform_physics_func(t:Callable):
	_perform_physics = t


func get_effects():
	return _effects


func get_preconditions():
	return _preconditions


func get_cost():
	return _cost


