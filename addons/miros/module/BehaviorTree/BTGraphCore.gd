@tool
extends ModuleCore

var bt_graph_editor_tscn = preload("res://addons/miros/module/BehaviorTree/Util/BTGraphEditor/BTGraphEditor.tscn")
var bt_graph_inspector_plugin_gd = preload("res://addons/miros/module/BehaviorTree/Util/BTGraphEditor/BTGraphInspectorPlugin.gd")

var bt_graph_editor:Control
var bt_graph_inspector_plugin:EditorInspectorPlugin

func start():
	bt_graph_editor = bt_graph_editor_tscn.instantiate()
	bt_graph_inspector_plugin = bt_graph_inspector_plugin_gd.new()
	bt_graph_editor.set_plugin(plugin)
	plugin.add_control_to_bottom_panel(bt_graph_editor,"BTGraph Editor")
	plugin.add_inspector_plugin(bt_graph_inspector_plugin)

func over():
	plugin.remove_control_from_bottom_panel(bt_graph_editor)
	plugin.remove_inspector_plugin(bt_graph_inspector_plugin)
	if bt_graph_editor != null:
		bt_graph_editor.queue_free()
