extends "BTCompsiteBase.gd"



static func _next(e:BTEngine,result:int)->String:
	var next_node_name:String
	var node_data = e.current_node_data
	var right_nodes_name = node_data["right_nodes_name"]
	var right_nodes_size = right_nodes_name.size()
	match result:
		e.TASK_STATE.NULL:
			next_node_name = "keep"
		e.TASK_STATE.SUCCEED:
			if right_nodes_size == 0:
				next_node_name = "over"
			elif right_nodes_size == 1:
				return right_nodes_name[0]
			else:
				var index = randi()%right_nodes_size
				next_node_name = right_nodes_name[index]
		e.TASK_STATE.FAILED:
			next_node_name = "back"
		e.TASK_STATE.RUNNING:
			next_node_name = "keep"
	return next_node_name
