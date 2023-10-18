extends Node
class_name  GPC

var _actions := []
var _actions_execute := {}
var _actions_last_execute := {}
var _action_layers := []

var _data_sensor:GPCDataSensor



func _init(actions:Array,dataSensor) -> void:
	self.name = "GPC"

	_data_sensor = dataSensor
	_actions = actions
	
	for action in _actions:
		var layer = action.get_layer()
		if  not _action_layers.has(layer):
			_action_layers.append(layer)
			_actions_execute[layer] = null
			_actions_last_execute[layer] = null


func _process(delta: float) -> void:
	_actions_last_execute = _actions_execute.duplicate()
	_update_actions_execute_and_record()

	for layer in _action_layers:
		var last_action = _actions_last_execute[layer]
		var current_action = _actions_execute[layer]
		if last_action != current_action:
			if last_action != null:last_action.exit() 
			if current_action != null:current_action.enter()
			
	for action in _actions_execute.values():
		if action == null:continue
		var perform_state = action.perform(delta)

		action.set_single_midle_state(perform_state,false)



func _physics_process(delta: float) -> void:
	for action in _actions_execute.values():
		if action == null:continue
		var perform_physics_state  = action.perform_physics(delta)

		action.set_single_midle_state(perform_physics_state,true)



# 判断动作是否能够执行（满足执行条件且在同一层级内优先级最高）
func _is_action_could_perform(action:GPCAction)->bool:
	var conditions: Dictionary = action.get_conditions()
	var could_perform = true

	for c_key in conditions.keys():
		if _data_sensor.get(c_key) is bool:
			if _data_sensor.get(c_key) != conditions[c_key]:
				could_perform = false
		elif _data_sensor.get(c_key) is Callable:
			could_perform = _data_sensor.get(c_key).call()

	return could_perform



# 更新 即将执行动作列表 与 动作记录
func _update_actions_execute_and_record():
	# 获取每层所有满足执行条件的动作，作为每层的预选动作
	var candidate_actions := {}
	
	for i in range(_actions.size()):
		var action = _actions[i]
		
		var layer = action.get_layer()
		var could_perform = _is_action_could_perform(action)
		if could_perform:
			if not candidate_actions.has(layer):
				candidate_actions[layer] = []
		
			candidate_actions[layer].append(action)
	
	# 将每层中的预选动作中优先级最高的动作,作为该层的下一个动作
	for layer in candidate_actions.keys():
		var candidate_action = candidate_actions[layer]
	
		if candidate_action.is_empty():
			return
		else:
			var current_action = _actions_execute[layer]
			var next_action = candidate_action[0]
			for a in candidate_action:
				if a.get_priority() >= next_action.get_priority():
					next_action = a
			
			if current_action  == null:
				_actions_execute[layer] = next_action
			else :
				var state = current_action.get_state()
			
				if state == STATE.ACTION_STATE.SUCCEED:
					_actions_execute[layer] = next_action

					var succeed_effects:Dictionary = current_action.get_succeed_effects()
					for ckey in succeed_effects.keys():
						_data_sensor.set(ckey,succeed_effects[ckey])

				elif state == STATE.ACTION_STATE.FAILED:
					_actions_execute[layer] = next_action

					var failed_effects = current_action.get_failed_effects()
					for ckey in failed_effects.keys():
						_data_sensor.set(ckey,failed_effects[ckey])

				elif state == STATE.ACTION_STATE.RUNNING:
					pass





