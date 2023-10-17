extends Node
class_name  GPC

var _actions_map := {}
var _variables := {}


var _actions_will := []

func _init(actions:Array,variables:Dictionary) -> void:
	_variables = variables
	
	for action in actions:
		#  给前置条件为空的action添加前置条件
#		if action.get_preconditions() == {}:
#			action._preconditions = {action.name : true}
#			_variables[action.name] = false
			
		_actions_map[action.name] = action
		
func _process(delta: float) -> void:
	_check_actions()
	
	for action in _actions_will:
		action.perform(delta)

func _physics_process(delta: float) -> void:
	for action in _actions_will:
		action.perform_physics(delta)


func _check_actions():
	for key in _actions_map.keys():
		var action = _actions_map[key]
		var conditions: Dictionary = action.get_preconditions()
		
		var could_perform = true
		for c_key in conditions.keys():
			if _variables[c_key] != conditions[c_key]:
				could_perform = false
		if could_perform:
			_actions_will.append(action)
			
			
func transform(action_name):
	if not _actions_map.has(action_name):return
	
	var action :GPCAction = _actions_map[action_name]
	var conditions = action.get_preconditions()
	
	for key in conditions.keys():
		_variables[key] = conditions[key]
		
