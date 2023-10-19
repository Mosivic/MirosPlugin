extends Node
class_name GPCGoalPlanner

var _goals:Array
var _actions :Array

var _current_goal
var _current_plan
var _current_plan_step = 0

@export var property_sensor:GPCPropertySensor
@export var actor:Node

var is_active := false

func _ready() -> void:
	if property_sensor == null:
		print("property sensor is null")
		return
		
	if actor == null:
		print("actor is null")
		return
	
	await actor.ready  #wait actor'children ready
	
	# init property sensor
	property_sensor.actor = actor
	
	# init actions and goals
	for node in get_node('Actions').get_children():
		if node is GPCAction:
			_actions.append(node)
			
			node.set_property_sensor(property_sensor)
			node.init()
	for node in get_node('Goals').get_children():
		if node is GPCGoal:
			_goals.append(node)

	# start loop
	is_active = true


func _process(delta):
	var goal = _get_best_goal()
	
	if _current_goal == null or goal != _current_goal:
		_current_goal = goal
		_current_plan = _caculate_best_plan(_current_goal)
		_current_plan_step = 0
	else:
		_follow_plan(delta)


# 获取当前最优目标goal
func _get_best_goal():
	var highest_priority_goal
	
	for goal in _goals:
		if goal.is_valid() and (highest_priority_goal == null or goal.get_priority() > highest_priority_goal.get_priority()):
			highest_priority_goal = goal
	
	return highest_priority_goal


# 按流程执行plan中的action
func _follow_plan(delta):
	if _current_plan.size() == 0:
		return
	
	var is_step_complete = _current_plan["actions"][_current_plan_step].perform(delta)
	if is_step_complete and _current_plan_step < _current_plan["actions"].size() -1 :
		_current_plan_step += 1


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
		var effects = action.get_effects()
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
