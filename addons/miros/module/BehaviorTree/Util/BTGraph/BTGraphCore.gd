tool
extends Control

const FILE_MODE = {
	NULL=0,
	SAVE=1,
	LOAD=2
}
var file_mode = FILE_MODE.NULL

onready var file_dialog:FileDialog = get_node("./UI/FileDialog")
# 行为树Graph
onready var graph = $GraphEdit

onready var ui = $UI
# 动作数据库
const ActionBD = preload("res://addons/miros/module/Action/ActionBD.gd")
# 行为树类数据库
const BTClassBD = preload("res://addons/miros/module/BehaviorTree/Util/BTClassDB.gd")
# 行为树节点
var bt_gragh_node = preload("res://addons/miros/module/BehaviorTree/Util/BTGraph/BTGraphNode.tscn")
# 插件类引用
var _plugin:EditorPlugin
# Graph数据，key为node名称，value为node信息
var graph_data = {}
# Graph中被选中的GraphNode
var selected_node:GraphNode


func set_plugin(value:EditorPlugin):
	_plugin = value
	if not self.is_inside_tree():
		yield(self,"ready")
		
	ui.init(self)
	_clear_graph()


# 实例化节点
func _add_node(node_type:String,node_name:String="",offset:Vector2 = Vector2.ZERO,action_name:String=""):
	var n = bt_gragh_node.instance()
	n.graph = self
	n.type = node_type
	# 节点实例命名方式 节点类型 + _ + 节点实例id
	if node_name == "":
		n.name = node_type + "_" +str(n.get_instance_id())
	else:
		n.name = node_name
	n.title = n.name
	n.offset = offset
	n.action_name = action_name
	graph.add_child(n)
	
	


# 连接节点, from为左节点name,to为右节点name
func _on_GraphEdit_connection_request(from, from_slot, to, to_slot):
	graph.connect_node(from, from_slot, to, to_slot)
	_add_node_link_info(from,to)
	

# 连接完成后各自将对方节点加入到节点信息中
func _add_node_link_info(from:String,to:String):
	var left = _get_node_by_name(from)
	var right = _get_node_by_name(to)
	left.add_right_node(right)
	right.add_left_node(left)

func _get_node_by_name(_name:String)->Node:
	var node = graph.get_node(_name)
	if node == null:
		print("BTGraphCore:Can not get node with name: "+_name)
		return node
	else:
		return node

# 解除连接后清楚双方节点的节点信息
func _remove_node_link_info(from:String,to:String):
	var left = _get_node_by_name(from)
	var right = _get_node_by_name(to)
	left.remove_node(right)
	right.remove_node(left)


func _make_graph_data():
	if graph.get_child_count() == 0:return
	graph_data.clear()
	for node in graph.get_children():
		if not node is GraphNode:continue
		var left_nodes_name = []
		var right_nodes_name = []
		for l in node.left_nodes:
			left_nodes_name.append(l.name)
		for r in node.right_nodes:
			right_nodes_name.append(r.name)
		var info = {
			"name":node.name,
			"type":node.type,
			"left_nodes_name":left_nodes_name,
			"right_nodes_name":right_nodes_name,
			"offset":node.offset, #self position
			"action_name":node.action_name
		}
		graph_data[node.name] = info


func _load_graph_from_data():
	for node_data in graph_data.values():
		_add_node(node_data["type"],node_data["name"],node_data["offset"],node_data["action_name"])
	print(graph.get_children())
	# 创建结点间连接
	for node_data in graph_data.values():
		var node_name = node_data["name"]
		# 创建左连接
		for l in node_data["left_nodes_name"]:
			_on_GraphEdit_connection_request(l,0,node_name,0)
		# 创建右连接
		for r in node_data["right_nodes_name"]:
			_on_GraphEdit_connection_request(node_name,0,r,0)


# 将行为树节点信息封装为data
func _pack_graph_data(c_node:GraphNode)->Dictionary:
	var data:Dictionary
	var c_node_info = {
		"name":c_node.name,
		"type":c_node.type,
		"lns":[], # link nodes info
		"offset":c_node.offset, #self position
		"action":c_node.action_name
		}
	for n in c_node.right_nodes:
		c_node_info["lns"].append(_pack_graph_data(n))
	data = c_node_info
	return data


# 销毁所有结点与连接
func _clear_graph():
	for node in graph.get_children():
		if node is GraphNode:
			graph.remove_child(node)
			node.queue_free()
	graph.clear_connections()
	selected_node = null
	graph.set_selected(null)
	refresh_inspecter()


func refresh_inspecter():
	_plugin.get_editor_interface().inspect_object(self)
	#_plugin.get_editor_interface().get_inspector().refresh()

func _parse_begin(plugin:EditorInspectorPlugin):
	# 创建标题栏
	plugin.add_custom_control(UIBuilder.create_category_header())
	# 创建节点类型选择
	plugin.add_custom_control(HSeparator.new())
	
	var vbox = HBoxContainer.new()
	var dropdown = OptionButton.new()
	for key in BTClassBD.BTNode:
		dropdown.add_item(key)
	vbox.add_child(dropdown)
	var createNodebutton = Button.new()
	createNodebutton.text = "Create"
	createNodebutton.connect("pressed",self,"_on_createNodeButton_pressed",[dropdown])
	createNodebutton.size_flags_horizontal = Control.SIZE_EXPAND + Control.SIZE_SHRINK_END
	vbox.add_child(createNodebutton)
	plugin.add_custom_control(vbox)
	
	plugin.add_custom_control(HSeparator.new())
	# 创建保存与加载按钮
	var hbox = HBoxContainer.new()
	var saveButton = Button.new()
	var loadButton = Button.new()
	saveButton.text = "Save"
	loadButton.text = "Load"
	saveButton.connect("button_down",self,"_on_SaveBtn_pressed")
	loadButton.connect("button_down",self,"_on_LoadBtn_pressed")
	hbox.add_child(saveButton)
	hbox.add_child(loadButton)
	plugin.add_custom_control(hbox)
	plugin.add_custom_control(HSeparator.new())
	# 创建构建Actions按钮
	var buildActionsButtion = Button.new()
	buildActionsButtion.text = "Build Actions"
	buildActionsButtion.connect("button_down",self,"build_actions")
	plugin.add_custom_control(buildActionsButtion)
	
	# 显示被选择结点
	if !selected_node == null:
		_parse_begin_node(plugin)
	


func _parse_begin_node(plugin:EditorInspectorPlugin):
	plugin.add_custom_control(UIBuilder.create_category_header(selected_node.name))

	var dropdown = OptionButton.new()
	for action in ActionBD.Actions:
		dropdown.add_item(action)
	#dropdown.connect("item_selected",self,"_on_item_selected",[dropdown])
	plugin.add_custom_control(dropdown)
	
	var label = Label.new()
	label.text = "Action"
	plugin.add_custom_control(label)
	
	var hbox = HBoxContainer.new()
	label = Label.new()
	label.text = "ActionName"
	var button = Button.new()
	button.text = selected_node.action_name
	hbox.add_child(label)
	hbox.add_child(button)
	plugin.add_custom_control(hbox)


func _on_createNodeButton_pressed(optionButton:OptionButton):
	var nodeName = optionButton.get_item_text(optionButton.selected)
	_add_node(nodeName)


func _on_SaveBtn_pressed():
	file_dialog.popup_centered()
	file_mode = FILE_MODE.SAVE

	

func _on_LoadBtn_pressed():
	file_dialog.popup_centered()
	file_mode = FILE_MODE.LOAD


func _on_GraphEdit_node_selected(node):
	selected_node = node
	refresh_inspecter()

func _on_GraphEdit_node_unselected(node):
	selected_node = null
	refresh_inspecter()


func _on_FileDialog_confirmed():
	if file_mode == FILE_MODE.SAVE:
		var path:String = file_dialog.current_path
		if path.split(".")[-1] == "res":
			var res =ResourceLoader.load(path)
			_make_graph_data()
			res.data = graph_data.duplicate(true)
			ResourceSaver.save(path,res)
		
	elif file_mode == FILE_MODE.LOAD:
		_clear_graph()
		var path = file_dialog.current_path
		var res = ResourceLoader.load(path)
		if !res.data.size() == 0:
			graph_data = res.data.duplicate(true)
			_load_graph_from_data()






