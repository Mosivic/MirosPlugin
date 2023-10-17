
extends Node
class_name GoaplAction

var _cost := 1000
var _preconditions := {}
var _effects := {}
var _layers := {}

var _enter:Callable = func():return
var _perform:Callable = func():return false
var _exit:Callable = func():return
var _is_valid:Callable = func():return true


func _init(cost:int=1000,preconditions:Dictionary={},effects:Dictionary={}):
	self._cost = cost
	self._effects = effects
	self._preconditions =preconditions

func is_valid() -> bool:
	return _is_valid.call()


func enter():
	return _enter.call()


func perform(delta) -> bool:
	return _perform.call()


func exit():
	return _exit.call()


func get_effects():
	return _effects


func get_preconditions():
	return _preconditions


func get_cost():
	return _cost

	
func get_layers():
	return _layers
