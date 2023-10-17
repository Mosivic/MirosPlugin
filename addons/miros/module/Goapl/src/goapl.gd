extends Node
class_name  Goapl


var _goals

var _current_goal
var _current_plan
var _current_plan_step = 0

var _planner:GoaplPlanner = null
var _layerer:GoaplLayer = null

func init(actions:Array,goals:Array,layers:Dictionary):
	_planner = GoaplPlanner.new(actions)
	_layerer = GoaplLayer.new(layers)
	_goals = goals
	

func _process(delta):
	if _planner == null:
		printerr("GOAPL: not initialization.")
		return
	
	var goal = _get_best_goal()
	
	if _current_goal == null or goal != _current_goal:
		_current_goal = goal
		_current_plan = _planner.get_plan(_current_goal)
		_current_plan_step = 0
	else:
		_follow_plan(delta)


func _get_best_goal():
	var highest_priority_goal
	
	for goal in _goals:
		if goal.is_valid() and (highest_priority_goal == null or goal.get_priority() > highest_priority_goal.get_priority()):
			highest_priority_goal = goal
	
	return highest_priority_goal


func _follow_plan(delta):
	if _current_plan.size() == 0:
		return
	
	var is_step_complete = _current_plan["actions"][_current_plan_step].perform(delta)
	if is_step_complete and _current_plan_step < _current_plan["actions"].size() -1 :
		_current_plan_step += 1

