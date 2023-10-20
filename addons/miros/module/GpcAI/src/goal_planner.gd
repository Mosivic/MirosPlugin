extends Node
class_name GPCGoalPlanner

var _goals:Array
var _actions :Array

var _current_goal
var _current_plan
var _current_plan_step = 0

var _current_action
var _last_action

var _actions_setting:GPCActionsSetting
var _goals_setting:GPCGoalsSetting

@export var property_sensor:GPCPropertySensor
@export var actor:Node


var is_active := false

func _ready() -> void:
	if property_sensor == null:
		print_debug("property sensor is null")
		return
		
	if actor == null:
		print_debug("actor is null")
		return
	
	await actor.ready  #wait actor'children ready
	
	# init property sensor
	property_sensor.actor = actor
	
	# init actions
	for node in get_node('Actions').get_children():
		if node is GPCAction:
			_actions.append(node)

			var setting = _actions_setting.get_setting()
			
			if setting.has(node.name):
				for key in setting[node.name].keys():
					node.set(key,setting[node.name][key])
					
			node.set_property_sensor(property_sensor)
			node.init()
			
	# init  goals
	for node in get_node('Goals').get_children():
		if node is GPCGoal:
			_goals.append(node)
			
			var setting = _goals_setting.get_setting()
			
			if setting.has(node.name):
				for key in setting[node.name].keys():
					node.set(key,setting[node.name][key])
					
			node.set_property_sensor(property_sensor)
			node.init()
			
	# start loop
	is_active = true


func _process(delta):
	if not is_active:return
	
	var goal = _get_best_goal()
	
	if _current_goal == null or goal != _current_goal:
		_current_goal = goal
		_current_plan = _caculate_best_plan(_current_goal)
		
	
		if _current_plan.size() == 0:
			return
		else:
			_current_plan_step = 0
			_last_action = null
			_current_action  = _current_plan['actions'][_current_plan_step]
	else:
		_follow_plan(delta)


func _physics_process(delta: float) -> void:
	if _current_action != null:
		var state = _current_action.perform_physics(delta)
		_current_action.set_single_midle_state(state,true)


# 按流程执行plan中的action
func _follow_plan(delta):
	if _last_action == null:
		_current_action.enter()
		print(actor.name + " enter action :" + _current_action.name )
	elif _last_action != _current_action:
		_last_action.exit()
		_current_action.enter()
		print(actor.name + " enter action :" + _current_action.name )

	var state = _current_action.perform(delta)
	_current_action.set_single_midle_state(state,false)
	
	var result = _current_action.get_state()
	_last_action = _current_action
	
	if result == STATE.ACTION_STATE.SUCCEED :
		_current_action.succeed()
		
		var succeed_effects:Dictionary = _current_action.get_succeed_effects()
		for ckey in succeed_effects.keys():
				property_sensor.set(ckey,succeed_effects[ckey])
				
		if _current_plan_step < _current_plan["actions"].size() -1:
			_current_plan_step += 1
			_current_action = _current_plan['actions'][_current_plan_step]
		else:
			print(actor.name + " goal succeed:" + _current_goal.name )
			_current_goal = null
	elif result == STATE.ACTION_STATE.FAILED:
		_current_action.failed()
		
		var failed_effects:Dictionary = _current_action.get_failed_effects()
		for ckey in failed_effects.keys():
				property_sensor.set(ckey,failed_effects[ckey])


# 获取当前最优目标goal
func _get_best_goal():
	var highest_priority_goal
	
	for goal in _goals:
		if goal.is_valid() and (highest_priority_goal == null or goal.get_priority() > highest_priority_goal.get_priority()):
			highest_priority_goal = goal
	
	return highest_priority_goal


# 计算达到目标的最优计划
func _caculate_best_plan(goal:GPCGoal):
	var desired_state = goal.get_desired_state().duplicate()
	
	if desired_state.is_empty():
		return []
		
	var root = {
		action = goal,
		state = desired_state,
		children = []
	}
	
	if _build_plans(root):
		var plans = _transform_tree_into_array(root)
		return _get_cheapest_plan_in_plans(plans)
	
	return []
	

# 构建达到目标的所有计划
func _build_plans(node):
	var has_followup = false
	var state = node.state.duplicate()
	
	if state.is_empty():
		return true
	
	for action in _actions:
		if action.is_valid() == false:
			continue
		
		var should_use_action = false
		var effects = action.get_succeed_effects()
		var desired_state = state.duplicate()
		
		for s in desired_state:
			if desired_state[s] == effects.get(s):
				desired_state.erase(s)
				should_use_action = true
				
		if should_use_action:
			var conditions = action.get_conditions()
			for p in conditions:
				desired_state[p] = conditions[p]
			
			var parent_node = {
				action = action,
				state = desired_state,
				children = []
			}
			
			if desired_state.is_empty() or _build_plans(parent_node):
				node.children.push_back(parent_node)
				has_followup = true
		
	return has_followup


# 将计划树结构转变为计划数组
func _transform_tree_into_array(p):
	var plans = []
	
	if p.children.size() == 0:
		plans.push_back({
			actions = [p.action],
			cost = p.action.get_cost(),
		})
		
		return plans
		
	for c in p.children:
		for child_plan in _transform_tree_into_array(c):
			if p.action.has_method("get_cost"):
				child_plan.actions.push_back(p.action)
				child_plan.cost += p.action.get_cost()
			plans.push_back(child_plan)
	return plans


#  在计划中取得花费最少的计划
func _get_cheapest_plan_in_plans(plans):
	var cheapest_plan
	for p in plans:
		if cheapest_plan == null or p.cost < cheapest_plan.cost:
			cheapest_plan = p
	return cheapest_plan
