extends Node

# 行为树类数据库
const BTClassBD = preload("res://addons/miros/module/BehaviorTree/Util/BTClassDB.gd")


static func assemble_node(node:GraphNode)->GraphNode:
	var node_script = load(BTClassBD.BTNodeClass.node.node_class)
	match node_script:
		BTClassBD.BTNodeType.Root:
			pass
		BTClassBD.BTNodeType.Leaf:
			pass
		BTClassBD.BTNodeType.Decorator:
			pass
		BTClassBD.BTNodeType.Composite:
			pass
	return node

