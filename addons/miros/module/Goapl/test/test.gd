extends Node


# Goapl使用范例
func goapl():
	var goal_test = GoaplGoal.new(5,{ss = true})
	
	var action_test = GoaplAction.new(1,{},{ss = true})
	action_test._perform = func():
		print(str(name) + ":I find player!")
		return true
	
	var actions = [
		action_test
	]
	var goals = [
		goal_test
	]
	
	var goapl = Goapl.new()
	goapl.init(actions,goals,{})
	add_child(goapl)
