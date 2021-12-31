extends Reference

const BTNode = {
	Root = preload("res://addons/mros/module/BehaviorTree/BTRoot.gd"),
	CompositeSequence = preload("res://addons/mros/module/BehaviorTree/Node/Compsite/BTSequence.gd"),
	CompositeSelector = preload("res://addons/mros/module/BehaviorTree/Node/Compsite/BTSelector.gd"),
	CompositeParallel = preload("res://addons/mros/module/BehaviorTree/Node/Compsite/BTParallel.gd"),
	LeafAction = preload("res://addons/mros/module/BehaviorTree/Node/Leaf/BTAction.gd"),
	LeafCondition = preload("res://addons/mros/module/BehaviorTree/Node/Leaf/BTCondition.gd")
} 

const BTGraph = {
	
}

## 判断节点是否为行为树节点
static func is_bt_node(node:Node)->bool:
	for n in BTNode.values():
		if node is n:
			return true
	return false
