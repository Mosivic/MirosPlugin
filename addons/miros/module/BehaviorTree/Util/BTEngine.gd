extends Node
class_name BTEngine

const BTClassBD = preload("res://addons/miros/module/BehaviorTree/Util/BTClassDB.gd")
const ActionBD = preload("res://addons/miros/module/Action/ActionBD.gd")

const ACTION_STATE ={
	NULL=0,
	PREPARE=1,
	RUNNING=2,
	SUCCEED=3,
	FAILED=4,
}

const TASK_STATE={
	NULL=0,
	RUNNING=1,
	SUCCEED=2,
	FAILED=3,
}


var current_node
var current_node_name:String
var current_node_data:Dictionary
var current_node_action

var back_node_name_road:Array

# 拥有者
var actor:Node
# Graph结点数据
var graph_data:Dictionary setget set_graph_data
# 行为参数
var action_args:Dictionary
# 是否激活
var is_active:bool=false setget set_active


func _init(actor:Node,graph_data:Dictionary,action_args:Dictionary):
	self.action_args = action_args
	self.graph_data = graph_data
	self.actor = actor
	self.name = "BTEngine"
	actor.add_child(self)
	_generate_action() #生成action
	_set_current_node_root() #设置当前结点为Root
	
	
func _process(delta):
	if is_active:run(delta)


func run(delta):
	var state:int = current_node._task(self)
	match state:
		TASK_STATE.NULL: #TASK_STATE:NULL
			print_debug("BTEngine:current_node state is NULL.")
		TASK_STATE.SUCCEED: #TASK_STATE:SUCCEED
			print("BTEngine: "+current_node_name+" is succeed.")
			var next_name = current_node._next(self,state)
			_parse_next_node(next_name)
		TASK_STATE.FAILED: #TASK_STATE:FAILED
			print("BTEngine: "+current_node_name+" is failed.")
			var next_name = current_node._next(self,state)
			_parse_next_node(next_name)
		TASK_STATE.RUNNING: #TASK_STATE:RUNNING
			print("BTEngine: "+current_node_name+" is running.")
	pass


# 解析下一个结点
func _parse_next_node(next_node_name:String):
	match next_node_name:
		"":
			print("BTEngine:Err:next_node_name is null string")
		"keep":
			pass
		"back":
			if back_node_name_road.size() == 0:
				set_active(false)
			else:
				var back_node_name = back_node_name_road.pop_back()
				_set_current_node(back_node_name)
		"over":
			set_active(false)
		_:
			back_node_name_road.append(current_node_name)
			_set_current_node(next_node_name)

# 生成action,重建graph_data
func _generate_action():
	for key in graph_data.keys():
		var action_name = graph_data[key]["action_name"]
		if action_name == "":
			action_name = "ActionEmpty"
			graph_data[key]["action_name"] = action_name
		var action = ActionBD.Actions[action_name].new()
		action.set_action_args(action_args)
		graph_data[key]["action"] = action


# 设置当前结点为Root
func _set_current_node_root():
	for key in graph_data.keys():
		if graph_data[key]["type"] == "Root":
			var n:String =  BTClassBD.BTNode.Root
			current_node = load(n)
			current_node_name = graph_data[key]["name"] 
			current_node_data = graph_data[key]
			current_node_action = graph_data[key]["action"]
			return
	print_debug("BTEngine:graph_data has not root node")

# 切换当前结点
func _set_current_node(node_name:String):
	current_node_data = graph_data[node_name]
	current_node_name = node_name
	current_node = load(BTClassBD.BTNode[current_node_data["type"]])
	current_node_action = current_node_data["action"]
	#action重置
	current_node_action.reset()

func set_graph_data(_graph_data:Dictionary):
	graph_data = _graph_data


func set_active(v:bool):
	is_active = v
