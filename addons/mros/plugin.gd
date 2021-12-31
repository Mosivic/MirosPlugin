tool
extends EditorPlugin

var add_node_panel = preload("res://addons/mros/module/BehaviorTree/Util/AddNodePanel/AddNodePanel.tscn").instance()
const BTClassDB = preload("res://addons/mros/module/BehaviorTree/Util/BTClassDB.gd")
var bt_graph = preload("res://addons/mros/module/BehaviorTree/Util/BTGraph/BTGraph.tscn").instance()

func _enter_tree():
	# 添加Mros为autoload单例
	add_autoload_singleton("Mros","res://addons/mros/core/Mros.gd")
	add_node_panel.set_plugin(self)

	add_control_to_bottom_panel(add_node_panel,"Behavior Tree")
	add_control_to_bottom_panel(bt_graph,"BT Graph")
	bt_graph.set_plugin(self)

	# 自定义节点
#	for key in BTClassDB.BTNode:
#		add_custom_type(key, "Node", BTClassDB.BTNode[key], get_node_icon("Node")) 
	
	
func _exit_tree():
	remove_autoload_singleton("Mros")
#	for key in BTClassDB.BTNode:
#		remove_custom_type(key)
	remove_control_from_bottom_panel(add_node_panel)
	remove_control_from_bottom_panel(bt_graph)


func get_node_icon(node_name: String):
   return get_editor_interface().get_base_control().get_icon(node_name, "EditorIcons")


func handles(object:Object)->bool:
	if  BTClassDB.is_bt_node(object):
		return true
	else:
		return false
		
func make_visible(visible:bool)->void:
	if visible:
		add_node_panel.show()

