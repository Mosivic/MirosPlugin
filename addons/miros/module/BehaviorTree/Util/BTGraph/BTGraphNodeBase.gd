tool
extends GraphNode

var graph
var type
# 保存连接该节点的左右节点
var left_nodes:Array
var right_nodes:Array

export var action_name:String 

func _on_GraphNode_dragged(from, to):
	#graph._plugin.get_editor_interface().inspect_object(self)
	pass
	

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

#func _parse_begin(plugin:EditorInspectorPlugin):
#	plugin.add_custom_control(UIBuilder.create_category_header("Graph Node"))
#
#	var dropdown = OptionButton.new()
#	for action in graph.actions:
#		dropdown.add_item(action)
#	dropdown.connect("item_selected",self,"_on_item_selected",[dropdown])
#	plugin.add_custom_control(dropdown)
#
#func _on_item_selected(index:int,dropdown:OptionButton):
#	action_name = dropdown.get_item_text(index)
#	graph.refresh_inspecter()
	
	

