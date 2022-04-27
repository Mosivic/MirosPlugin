extends Node
class_name BTEngine

const BTClassBD = preload("res://addons/miros/module/BehaviorTree/Util/BTClassDB.gd")
const ActionBD = preload("res://addons/miros/module/Action/ActionBD.gd")

const ACTION_STATE={
	NULL = -1,
	PREPARE = 1,
	RUNNING = 2,
	SUCCEED = 3,
	FAILED = 0,
}

const TASK_STATE={
	NULL=0,
	RUNNING = 1,
	SUCCEED = 2,
	FAILED = 3,
}

const ACTION_FUNC_TYPE = {
	NULL = 0,
	PROCESS = 1,
	PHYSICS_PROCESS = 2,
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



var task_state:int  = TASK_STATE.NULL

var is_task_process:bool = false
var is_task_physics_process:bool = false

func _init(actor:Node,graph_data:Dictionary,action_args:Dictionary):
	self.action_args = action_args
	self.graph_data = graph_data
	self.actor = actor
	self.name = "BTEngine"
	actor.add_child(self)
	generate_action() #生成action
	set_current_node_root() #设置当前结点为Root


func _process(delta):
	if is_active :
		state_check()
		run_process(delta)

func _physics_process(delta):
	if is_active:
		run_physics_process(delta)



func run_process(delta):
	task_state = current_node._task(self,ACTION_FUNC_TYPE.PROCESS,delta)

func run_physics_process(delta):
	task_state = current_node._task(self,ACTION_FUNC_TYPE.PHYSICS_PROCESS,delta)


func state_check():
	match task_state:
		TASK_STATE.NULL:
			pass
		TASK_STATE.RUNNING:
			print("BTEngine: "+current_node_name+" is running..")
		TASK_STATE.SUCCEED:
			print("BTEngine: "+current_node_name+" is succeed.")
			var next_name = current_node._next(self,TASK_STATE.SUCCEED)
			switch_next_task(next_name)
		TASK_STATE.FAILED:
			print("BTEngine: "+current_node_name+" is failed.")
			var next_name = current_node._next(self,TASK_STATE.FAILED)
			switch_next_task(next_name)

# 
func switch_next_task(next_node_name:String):
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
				set_current_node(back_node_name)
		"over":
			set_active(false)
		_:
			back_node_name_road.append(current_node_name)
			set_current_node(next_node_name)

# 生成action,重建graph_data
# 给原有的data上添加实例化的action引用
func generate_action():
	for key in graph_data.keys():
		var action_name = graph_data[key]["action_name"]
		var action = ActionBD.Actions[action_name].new()
		action.set_action_args(action_args)
		graph_data[key]["action"] = action


# 设置当前结点为Root
func set_current_node_root():
	for key in graph_data.keys():
		if graph_data[key]["node_class"] == "Root":
			var k = graph_data[key]["node_class"]
			current_node = load(BTClassBD.BTNodeClass[k])
			current_node_name = graph_data[key]["name"] 
			current_node_data = graph_data[key]
			current_node_action = graph_data[key]["action"]
			return
	print_debug("BTEngine:graph_data has not root node")

# 切换当前结点
func set_current_node(node_name:String):
	current_node_data = graph_data[node_name]
	current_node_name = node_name
	var k = current_node_data["node_class"]
	current_node = load(BTClassBD.BTNodeClass[k])
	current_node_action = current_node_data["action"]
	#action重置, 当前结点与其子结点, state重置
	current_node_action.reset()
	for child_node_name in current_node_data["children_node"]:
		graph_data[child_node_name]["action"].reset()
	task_state = TASK_STATE.NULL


func reset_task_action(node_data):
	node_data["action"].reset() 

func set_graph_data(_graph_data:Dictionary):
	graph_data = _graph_data


func set_active(v:bool):
	is_active = v
	
func get_decorator_script(_name:String):
	var decorator = load(BTClassBD.BTDecoratorType[_name])
	return decorator

