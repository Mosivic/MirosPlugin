extends "res://addons/miros/module/BehaviorTree/Node/BTNode.gd"


static func _next(e:BTEngine,result:int)->String:
	var next_node_name:String
	var right_nodes_name = e.current_node_data["right_nodes_name"]
	match result:
		e.TASK_STATE.NULL:
			next_node_name =  "keep"
		e.TASK_STATE.SUCCEED:
			if right_nodes_name.size() != 0:
				next_node_name = right_nodes_name[0]
			else:
				next_node_name = "over"
		e.TASK_STATE.FAILED:
			next_node_name = "back"
	return next_node_name
