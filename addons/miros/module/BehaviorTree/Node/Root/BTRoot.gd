extends "res://addons/miros/module/BehaviorTree/Node/BTNode.gd"

const Blackboard = preload("res://addons/miros/module/BehaviorTree/Util/BTBlackboard.gd")
var blackboard

export(bool) var is_active = false setget _set_active


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




	

