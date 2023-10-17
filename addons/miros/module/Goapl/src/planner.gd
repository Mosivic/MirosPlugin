extends Node
class_name GoaplPlanner


var _actions :Array

func _init(actions:Array):
	_actions = actions


func get_plan(goal:GoaplGoal):
	var desired_state = goal.get_desired_state().duplicate()
	
	if desired_state.is_empty():
		return []
		
	return _find_best_plan(goal,desired_state)


func _find_best_plan(goal,desired_state):
	var root = {
		action = goal,
		state = desired_state,
		children = []
	}
	
	if _build_plans(root):
		var plans = _transform_tree_into_array(root)
		print(plans)
		return _get_cheapest_plan(plans)
	
	return []
	
	
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
			var preconditions = action.get_preconditions()
			for p in preconditions:
				desired_state[p] = preconditions[p]
			
			var parent_node = {
				action = action,
				state = desired_state,
				children = []
			}
			
			if desired_state.is_empty() or _build_plans(parent_node):
				node.children.push_back(parent_node)
				has_followup = true
		
		return has_followup


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


func _get_cheapest_plan(plans):
	var cheapest_plan
	for p in plans:
		if cheapest_plan == null or p.cost < cheapest_plan.cost:
			cheapest_plan = p
	return cheapest_plan
	
