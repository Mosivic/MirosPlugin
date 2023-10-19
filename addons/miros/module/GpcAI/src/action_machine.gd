extends Node
class_name  GPCActionMachine

var _actions := []
var _actions_execute := {}
var _actions_last_execute := {}
var _action_layers := []

@export var property_sensor:GPCPropertySensor
@export var actor:Node



var is_active := false

var _actions_setting:GPCActionsSetting

func _ready() -> void:
	if property_sensor == null:
		print("property sensor is null")
		return
		
	if actor == null:
		print("actor is null")
		return
	
	await actor.ready  #wait actor'children ready
	
	# init property
	property_sensor.actor = actor
	
	# init actions
	for node in get_children():
		if node is GPCAction:
			_actions.append(node)
			
			var setting = _actions_setting.get_setting()
			
			if setting.has(node.name):
				for key in setting[node.name].keys():
					node.set(key,setting[node.name][key])
			
			node.set_property_sensor(property_sensor)
			node.init()

			var layer = node.get_layer()
			if  not _action_layers.has(layer):
				_action_layers.append(layer)
				_actions_execute[layer] = null
				_actions_last_execute[layer] = null
	
	# start loop
	is_active = true


func _process(delta: float) -> void:
	if not is_active: return
	
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
	if not is_active: return
		
	for action in _actions_execute.values():
		if action == null:continue
		var perform_physics_state  = action.perform_physics(delta)

		action.set_single_midle_state(perform_physics_state,true)



# 判断动作是否能够执行（满足执行条件且在同一层级内优先级最高）
func _is_action_could_perform(action:GPCAction)->bool:
	var conditions: Dictionary = action.get_conditions()
	var could_perform = true

	for c_key in conditions.keys():
		if c_key is String: #
			if property_sensor.get(c_key) is bool:
				if property_sensor.get(c_key) != conditions[c_key]:
					could_perform = false
					break
			elif property_sensor.get(c_key) is Callable:
				if not property_sensor.get(c_key).call():
					could_perform = false
					break
		elif c_key is Callable:
			if not c_key.call():
				could_perform = false
				break

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
					current_action.succeed()
					for ckey in succeed_effects.keys():
						property_sensor.set(ckey,succeed_effects[ckey])

				elif state == STATE.ACTION_STATE.FAILED:
					_actions_execute[layer] = next_action

					var failed_effects = current_action.get_failed_effects()
					current_action.failed()
					for ckey in failed_effects.keys():
						property_sensor.set(ckey,failed_effects[ckey])

				elif state == STATE.ACTION_STATE.RUNNING:
					pass


func has_action_in_execute(action):
	return true if _actions_execute.find_key(action)  != null else false
		

