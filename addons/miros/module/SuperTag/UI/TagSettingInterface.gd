tool
extends Tabs

var tag_item_tscn = preload("res://addons/miros/module/SuperTag/UI/TagItem.tscn")

onready var resource_line = $HBoxContainer/TagPanel/HBoxContainer/ImportResource/LineEdit
onready var import_result_label = $HBoxContainer/TagPanel/HBoxContainer/ImportResult/ResultLabel
onready var add_tag_line = $HBoxContainer/TagPanel/HBoxContainer/AddTag/InputLine
onready var tags_list = $HBoxContainer/TagPanel/HBoxContainer/TagsContainer/VBoxContainer

var plugin:EditorPlugin
var setting:ModuleSettingResource

var tag_resource:TagResource

func init(_plugin,_setting):
	plugin = _plugin
	setting = _setting
	
	var extra:Dictionary = setting.extra
	if extra.has("tag_resource_path"):
		tag_resource = load(extra["tag_resource_path"])
		resource_line.text = str(tag_resource.resource_path)
		generate_tags_list()

func _on_ImportBtn_button_down():
	var path = resource_line.text
	var res = load(path)
	if not res is TagResource:
		import_result_label.text = "失败"
	else:
		import_result_label.text = "成功"
		tag_resource = res
		setting.extra["tag_resource_path"] = res.resource_path 
		generate_tags_list()

func generate_tags_list():
	for item in tags_list.get_children():
		item.queue_free()
	for tag in tag_resource.Tags:
		var tag_item = tag_item_tscn.instance()
		tag_item.name = tag
		tag_item.get_node("TagBtn").text = tag
		tag_item.get_node("DelBtn").connect("button_down",self,"on_DelBtn_button_down",[tag_item])
		tag_item.get_node("TagBtn").connect("button_down",self,"on_TagBtn_button_down",[tag_item])
		tags_list.add_child(tag_item)


func _on_AddBtn_button_down():
	var tag = add_tag_line.text
	if tag == "" or tag_resource.Tags.has(tag):return
	tag_resource.Tags.append(tag)
	generate_tags_list()

func on_DelBtn_button_down(tag_item):
	pass
	
func on_TagBtn_button_down(tag_item):
	pass

# 保持TagResource
func _on_SaveBtn_button_down():
	ResourceSaver.save(tag_resource.resource_path,tag_resource)
