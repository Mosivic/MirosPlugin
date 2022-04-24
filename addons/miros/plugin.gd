tool
extends EditorPlugin

var add_node_panel = preload("res://addons/miros/module/BehaviorTree/Util/AddNodePanel/AddNodePanel.tscn").instance()
const BTClassDB = preload("res://addons/miros/module/BehaviorTree/Util/BTClassDB.gd")
var bt_graph = preload("res://addons/miros/module/BehaviorTree/Util/BTGraph/BTGraph.tscn").instance()
var bt_grath_inspector_plugin = preload("res://addons/miros/module/BehaviorTree/Util/BTGraph/BTGraphInspectorPlugin.gd")

func _enter_tree():
	# 添加Miros为autoload单例
	add_autoload_singleton("Miros","res://addons/miros/core/Miros.gd")
	add_node_panel.set_plugin(self)
	# 添加InspectorPlugun
	bt_grath_inspector_plugin = bt_grath_inspector_plugin.new()
	add_inspector_plugin(bt_grath_inspector_plugin)
	# 添加底部扩展面板
	add_control_to_bottom_panel(add_node_panel,"Behavior Tree")
	add_control_to_bottom_panel(bt_graph,"BT Graph")
	bt_graph.set_plugin(self)
	

	# 自定义节点
#	for key in BTClassDB.BTNode:
#		add_custom_type(key, "Node", BTClassDB.BTNode[key], get_node_icon("Node")) 
	
	
func _exit_tree():
	remove_autoload_singleton("Miros")
	remove_inspector_plugin(bt_grath_inspector_plugin)
#	for key in BTClassDB.BTNode:
#		remove_custom_type(key)
	remove_control_from_bottom_panel(add_node_panel)
	remove_control_from_bottom_panel(bt_graph)


func get_node_icon(node_name: String):
	return get_editor_interface().get_base_control().get_icon(node_name, "EditorIcons")


#func handles(object:Object)->bool:
#	if  BTClassDB.is_bt_node(object):
#		return true
#	else:
#		return false
		
func make_visible(visible:bool)->void:
	if visible:
		add_node_panel.show()

