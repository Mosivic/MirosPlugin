extends WeakRef
class_name  GPCGoalsSetting

var _setting := {}

func set_setting(setting):
	_setting = setting

func get_setting():
	return _setting


func get_goal_seting(goal_name):
	if _setting.has(goal_name):
		return _setting[goal_name]
	else :
		return {}


func get_goal_priority(goal_name) -> int:
	var key = 'priority'
	if get_goal_seting(goal_name).has(key):
		return _setting[goal_name][key]
	else:
		return 0


func get_goal_desired_state(goal_name) -> Dictionary:
	var key = 'desired_state'
	if get_goal_seting(goal_name).has(key):
		return _setting[goal_name][key]
	else:
		return {}


func get_goal_jobs_setting(goal_name)->GPCJobsSetting:
	var key = 'jobs_setting'
	if get_goal_seting(goal_name).has(key):
		return _setting[goal_name][key]
	else:
		return null
