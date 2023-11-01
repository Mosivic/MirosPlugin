extends WeakRef
class_name  GPCPlanner


var _goals :Dictionary
var _jobs :Dictionary
var _property_sensor:GPCPropertySensor

var _blacklist_goals:Array = []


func add_goal_to_blacklist(goal_name):
	if not _blacklist_goals.has(goal_name):
		_blacklist_goals.append(goal_name)


func _init(goals,jobs,property_sensor) -> void:
	_goals = goals
	_jobs = jobs
	_property_sensor = property_sensor


# 获取当前最优目标goal
func get_best_goal():
	var highest_priority_goal = null
	
	for key in _goals.keys():
		if _blacklist_goals.has(key):continue
		
		var goal = _goals[key]
		if ( goal.can_execute() and (highest_priority_goal == null or  
			(_property_sensor.get_goals_setting().get_goal_priority(goal.name) > _property_sensor.get_goals_setting().get_goal_priority(highest_priority_goal.name)))
		):
			
			highest_priority_goal = goal
	
	if highest_priority_goal == null:
		printerr('No valid goal.')
	else:
		return highest_priority_goal


# 计算达到目标的最优计划
func get_best_plan(goal:GPCGoal):
	var desired_state_temp = _property_sensor.get_goals_setting().get_goal_desired_state(goal.name).duplicate() 
	
	if desired_state_temp.is_empty():
		return {}
		
	var root = {
		job = goal,
		desired_state = desired_state_temp,
		children = []
	}
	
	if _build_plans(root):
		var plans = _transform_tree_into_array(root)
		return _get_cheapest_plan_in_plans(plans)
	
	return {}
	

# 构建达到目标的所有计划(反向)
func _build_plans(node):
	var has_followup = false
	var desired_state = node.desired_state.duplicate()
	
#	for key in node.desired_state.keys():
#		if desired_state[key] == property_sensor.get(key):
#			desired_state .erase(key)
	
	if desired_state.is_empty():
		return true
	
	for job in _jobs.values():
#		if action.is_valid() == false:
#			continue
		
		var should_use_action = false
		var effects =  _property_sensor.get_jobs_setting().get_job_succeed_effects(job.name)
		var desired_state_copy = desired_state.duplicate()
		
		for s in desired_state_copy:
			if desired_state_copy[s] == effects.get(s):
				desired_state_copy.erase(s)
				should_use_action = true
				
		if should_use_action:
			var conditions = _property_sensor.get_jobs_setting().get_job_preconditions(job.name)
			for p in conditions:
				desired_state_copy[p] = conditions[p]
			
			var parent_node = {
				job = job,
				desired_state = desired_state_copy,
				children = []
			}
			
			if desired_state_copy.is_empty() or _build_plans(parent_node):
				node.children.push_back(parent_node)
				has_followup = true
		
	return has_followup


# 将计划树结构转变为计划数组
func _transform_tree_into_array(p):
	var plans = []
	
	if p.children.size() == 0:
		plans.push_back({
			jobs = [p.job],
			cost = _property_sensor.get_jobs_setting().get_job_cost(p.job.name),
		})
		
		return plans
		
	for c in p.children:
		for child_plan in _transform_tree_into_array(c):
			if p.job.has_method("get_cost"):
				child_plan.jobs.push_back(p.job)
				child_plan.cost += _property_sensor.get_jobs_setting().get_job_cost(p.job.name)
			plans.push_back(child_plan)
	return plans


#  在计划中取得花费最少的计划
func _get_cheapest_plan_in_plans(plans):
	var cheapest_plan
	for p in plans:
		if cheapest_plan == null or p.cost < cheapest_plan.cost:
			cheapest_plan = p
	return cheapest_plan
