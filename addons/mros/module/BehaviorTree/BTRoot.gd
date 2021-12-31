
extends "BTNode.gd"

const Blackboard = preload("BTBlackboard.gd")
var blackboard

export(bool) var is_active = false setget _set_active
export(NodePath) var host setget _set_host

export(Array) var host_functions setget _set_host_function

func _physics_process(delta):
	if is_active:
		get_child(0)._task()
	
func _init_data():
	root = self
	actor.get_parent()
	blackboard = Blackboard.new()

## 将所有节点的根节点设置为自己
func _init_node(node:Node):
	node.actor = self.actor
	node.root = self.root
	if node.has_method("set_blackboard"):
		node.blackboard = self.blackboard
		
	for child in node.get_children():
		_init_node(child)

func _set_active(value):
	if value == true:
		_init_data()
		_init_node(self)
	is_active = value

func _set_host(value):
	host = value
	var names = _get_script_func_name(get_node(value))
	_set_host_function(names)
	

func _set_host_function(value):
	host_functions = value

	
func _get_script_func_name(node:Node)->Array:
	var functions = node.get_script().get_script_method_list()
	var names = []
	for f in functions:
		var n = f["name"]
		if not names.has(n):
			names.append(f["name"])
	return names
