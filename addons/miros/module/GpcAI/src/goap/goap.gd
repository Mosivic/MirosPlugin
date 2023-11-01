extends Node
class_name GPCGoap

var _goals :Dictionary
var _jobs :Dictionary

var _jobs_setting:GPCJobsSetting
var _goals_setting:GPCGoalsSetting

var _current_goal:GPCGoal
var _current_plan:Dictionary

var _default_goal:GPCGoal


@export var property_sensor:GPCPropertySensor
@export var actor:Node

var _planner :GPCPlanner

var _tmp_jobs_setting:Dictionary
var _tmp_goals_setting:Dictionary


func _ready() -> void:
	if property_sensor == null:
		print_debug("property sensor is null")
		return
		
	if actor == null:
		print_debug("actor is null")
		return
	
	await actor.ready  #wait actor'children ready
	
	# init property sensor
	property_sensor.set_actor(actor)
	property_sensor.set_jobs_setting(_tmp_jobs_setting)
	property_sensor.set_goals_setting(_tmp_goals_setting)
	
	# init jobs
	
	for job in get_children():
		_jobs[job.name] = job
		job.set_property_sensor(property_sensor)
		job.set_actor(property_sensor.get_actor())


	# init  goals
	for key in _tmp_goals_setting.keys():
		
		var goal = GPCGoal.new()
		goal.name = key
		for p_key in tmp_goals_setting[key].keys():
			goal.set(p_key,tmp_goals_setting[key][p_key])

		goal.set_property_sensor(property_sensor)
		_goals[key] = goal
	
	_planner = GPCPlanner.new(_goals,_jobs,property_sensor)


func _process(delta):
	_update_current_goal_and_plan()
	
	if _current_goal != null:
		_current_goal.execute(delta,false)
	


func _physics_process(delta: float) -> void:
	if _current_goal != null:
		_current_goal.execute(delta,true)



# 更新当前目标与规划
func _update_current_goal_and_plan():
	var next_goal = _planner.get_best_goal()
	
	if _current_goal == null:
		_current_goal = next_goal
		_verify_current_goal_plan()
		_current_goal.enter(_current_plan['jobs'])
		
	elif _current_goal != next_goal:
		_current_goal.exit()
		_current_goal = next_goal
		_verify_current_goal_plan()
		_current_goal.enter(_current_plan['jobs'])
	
	elif _current_goal.get_state() == GPC.GoalState.SUCCEED:  # 目标完成
		_current_goal.exit()
		_current_goal = next_goal
		_verify_current_goal_plan()
		_current_goal.enter(_current_plan['jobs'])
		
	elif  _current_goal.get_state() == GPC.GoalState.FAILED:  # 目标失败
		_current_goal.exit()
		_current_goal = next_goal
		_verify_current_goal_plan()
		_current_goal.enter(_current_plan['jobs'])
		
	elif _current_goal.get_state() == GPC.GoalState.RUNNING:  # 目标执行中
		pass


# 校验当前目标与规划
func _verify_current_goal_plan():
	_current_plan = _planner.get_best_plan(_current_goal)
	
	if _current_plan == {} or _current_plan['jobs'].is_empty(): 
		_current_goal = null
		_current_plan  = {}
		_planner.add_goal_to_blacklist(_current_goal.name)
		
		_update_current_goal_and_plan()



