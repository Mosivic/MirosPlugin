tool
extends Control

# 动作数据库
const ActionBD = preload("res://addons/miros/module/Action/ActionBD.gd")
# 行为树类数据库
const BTClassBD = preload("res://addons/miros/module/BehaviorTree/Util/BTClassDB.gd")


onready var context_box = $Context/VBoxContainer
onready var context = $Context
onready var path = $Path

var graph_core 

var context_button_db:Dictionary

func init(core):
	graph_core = core


func _input(event):
	if event.is_pressed(): 
		if event.button_index == BUTTON_RIGHT:
			if graph_core.selected_node == null:
				_build_main_context()
			else:
				_build_node_operate_context()

# 显示Inspector
func _show_inspector(b:Button):
	graph_core.refresh_inspecter()
	_hide_context()

# 创建结点
func _on_create_node_button_pressed(b:Button):
	var data = b.get_meta("bt_data")
	var node = graph_core._create_node({
		"node_class":data.node_class,
	})
	graph_core._set_node_child(node)
	_hide_context()

# 选择Ation
func _on_choose_action_button_pressed(b:Button):
	if graph_core.selected_node != null:
		graph_core.selected_node.set_action_name(b.text)
	_hide_context()

# 删除结点
func _on_delete_node_pressed(b:Button):
	graph_core._delete_node(graph_core.selected_node)
	graph_core.selected_node = null
	_hide_context()

# 创建子图
func _generate_child_graph(b:Button):
	var n = graph_core.selected_node
	graph_core._create_child_graph(n.name)
	graph_core.selected_node = null
	_hide_context()

# 主上下文
func _build_main_context():
	_clear_context()
	_generate_context_button("创建结点","_build_create_node_context")
	_generate_context_button("显示Inspector","_show_inspector")
	_show_context()
	
# 创建结点上下文
func _build_create_node_context(b:Button):
	_clear_context()
	for key in BTClassBD.BTNodeClass:
		_generate_context_button(
			key,
			"_on_create_node_button_pressed",
			"bt_data",
			{
				node_class = key,
			}
		)
	_show_context()

# 结点操作上下文
func _build_node_operate_context():
	_clear_context()
	_generate_context_button("选择行为","_build_choose_action_context")
	_generate_context_button("添加装饰","_add_decoretor_context")
	_generate_context_button("创建子图","_generate_child_graph")
	_generate_context_button("进入子图","_enter_child_graph")
	_generate_context_button("删除子图","_delete_child_graph")
	_generate_context_button("删除结点","_on_delete_node_pressed")
	_show_context()

# 选择结点行为上下文
func _build_choose_action_context(b:Button):
	_clear_context()
	for key in ActionBD.Actions:
		_generate_context_button(key,
			"_on_choose_action_button_pressed",
			"bt_data",
			{
				script = ActionBD.Actions[key] ,
				type = key,
			}
		)
	_show_context()

func _clear_context():
	for c in context_box.get_children():
		context_box.remove_child(c)
		

func _show_context():
	context.rect_global_position = get_global_mouse_position()
	context.show()

func _hide_context():
	context.hide()


# 生成上下文按钮
func _generate_context_button(text:String,event_name:String="",meta_name:String="",meta_data:Dictionary={},icon_name:String="Node"):
	if context_button_db.has(text) and context_button_db[text]!=null:
		context_box.add_child(context_button_db[text])
		return
	var b = Button.new()
	b.text = text
	b.rect_min_size = Vector2(100,40)
	if meta_name != "":
		b.set_meta(meta_name,meta_data)
	if event_name != "":
		b.connect("button_down",self,event_name,[b])
	_set_button_icon(b,icon_name)
	context_box.add_child(b)
	context_button_db[text] = b

	
# 设置按钮图标
func _set_button_icon(b:Button,icon_name:String="Node"):
	b.icon = graph_core._plugin.get_editor_interface().get_base_control().get_icon(icon_name,"EditorIcons")


func _set_path():
	for child in path.get_children():
		path.remove_child(child)
		child.queue_free()
	
	var road:Array
	var current_layer = graph_core.current_layer
	while true:
		if current_layer == graph_core.parent_node:
			road.insert(0,current_layer)
			break
		else:
			var n = graph_core._get_node_by_name(current_layer)
			road.insert(0,current_layer)
			current_layer = n.parent_node
	
	for i in road:
		var b = ToolButton.new()
		b.text = i + "/"
		b.connect("button_down",self,"_on_path_button_pressed",[i])
		path.add_child(b)

func _add_decoretor_context(b:Button):
	_clear_context()
	for key in BTClassBD.BTDecoratorType:
		_generate_context_button(key,
			"_on_add_decoretor_button_pressed",
			"bt_data",
			{
				script = BTClassBD.BTDecoratorType[key] ,
				type = key,
			}
		)
	_show_context()

func _on_add_decoretor_button_pressed(b:Button):
	if graph_core.selected_node != null:
		graph_core.selected_node.add_decorator(b.get_meta("bt_data")["type"])
	_hide_context()
	
# 路径按钮按下
# 跳转子图
# 重构路径
# 取消结点选择， 隐藏上下文
func _on_path_button_pressed(parent):
	graph_core._jump_graph(parent)
	graph_core.selected_node = null
	_hide_context()
	_set_path()

# 进入子图按钮按下
# 跳转子图
# 重构路径
# 取消结点选择， 隐藏上下文
func _enter_child_graph(b:Button):
	var n = graph_core.selected_node
	graph_core._jump_graph(n.name)
	graph_core.selected_node = null
	_hide_context()
	_set_path()
