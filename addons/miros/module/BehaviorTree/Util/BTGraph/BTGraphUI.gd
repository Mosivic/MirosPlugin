tool
extends Control

# 动作数据库
const ActionBD = preload("res://addons/miros/module/Action/ActionBD.gd")
# 行为树类数据库
const BTClassBD = preload("res://addons/miros/module/BehaviorTree/Util/BTClassDB.gd")

onready var context_action = $ContextAction
onready var context_node = $ContextNode
var graph_core 


func _ready():
	context_node.visible = false
	context_action.visible = false
	
func init(core):
	graph_core = core
	# 建立contextNode操作UI
	for key in BTClassBD.BTNode:
		if key == "Root":continue
		var b = ToolButton.new()
		b.set_meta("bt_data",{
			script_path = BTClassBD.BTNode[key] ,
			type = key,
		})
		b.text = key
		b.connect("pressed",self,"_on_context_node_button_pressed",[b])
		b.icon = graph_core._plugin.get_editor_interface().get_base_control().get_icon("Node","EditorIcons")
		b.rect_min_size = Vector2(100,40)
		context_node.get_node("VBoxContainer").add_child(b)
	# 建立contextAction操作UI
	for key in ActionBD.Actions:
		var b = ToolButton.new()
		b.set_meta("bt_data",{
			script = ActionBD.Actions[key] ,
			type = key,
		})
		b.text = key
		b.connect("pressed",self,"_on_context_action_button_pressed",[b])
		b.icon = graph_core._plugin.get_editor_interface().get_base_control().get_icon("Node","EditorIcons")
		b.rect_min_size = Vector2(100,40)
		context_action.get_node("VBoxContainer").add_child(b)


func _on_context_node_button_pressed(b:Button):
	var data = b.get_meta("bt_data")
	var pos = get_global_mouse_position()
	
	graph_core._add_node(data.type,"",Vector2.ZERO,pos)
	
func _on_context_action_button_pressed(b:Button):
	pass


func _input(event):
	if event.is_pressed(): 
		if event.button_index == BUTTON_RIGHT:
			if graph_core.selected_node != null:
				show_context_node(event)
				print("node")
			else:
				show_context_action(event)
				print("action")
			


func show_context_node(event):
	context_node.rect_global_position = event.position
	context_node.visible = true
	context_action.visible = false

func show_context_action(event):
	context_action.rect_global_position = event.position
	context_action.visible = true
	context_node.visible = false




