tool
extends GraphNode

# 连接该节点的左右节点的字典,key为节点引用,value为节点自身信息
var left_nodes:Array
var right_nodes:Array


func _on_GraphNode_dragged(from, to):
	pass # Replace with function body.

func _on_GraphNode_resize_request(new_minsize):
	rect_size = new_minsize

# 添加左节点集
func add_left_node(node):
	if  !left_nodes.has(node) and node != null:
		left_nodes.append(node)

# 添加右节点集
func add_right_node(node):
	if not right_nodes.has(node) and node != null:
		right_nodes.append(node)

# 移除已删除节点
func remove_node(node):
	if left_nodes.has(node):
		left_nodes.erase(node)
	if right_nodes.has(node):
		right_nodes.erase(node)
	

