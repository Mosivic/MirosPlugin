@tool
extends TabBar

var tag_item_tscn = preload("res://addons/miros/module/SuperTag/UI/TagItem.tscn")

@onready var resource_line = $HBoxContainer/TagPanel/HBoxContainer/ImportResource/LineEdit
@onready var import_result_label = $HBoxContainer/TagPanel/HBoxContainer/ImportResult/ResultLabel
@onready var add_tag_line = $HBoxContainer/TagPanel/HBoxContainer/AddTag/InputLine
@onready var tags_list = $HBoxContainer/TagPanel/HBoxContainer/TagsContainer/VBoxContainer

var miros:Miros
var setting:ModuleSettingResource

var tag_resource:TagResource

func init(_miros,_setting):
	miros = _miros
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
	for key in tag_resource.tags:
		var tag_item = tag_item_tscn.instance()
		tag_item.name = key
		tag_item.get_node("TagBtn").text = key
		tag_item.get_node("DelBtn").connect("button_down",self,"on_DelBtn_button_down",[tag_item])
		tag_item.get_node("TagBtn").connect("button_down",self,"on_TagBtn_button_down",[tag_item])
		tags_list.add_child(tag_item)


func _on_AddBtn_button_down():
	var tag_path = add_tag_line.text
	var tag_script = load(tag_path)
	if not tag_script is TagBase:
		miros.show_tip("添加的脚本路径不是TagBase脚本.")
	else:
		var tag_name = (tag_script as TagBase).tag_name
		tag_resource.tags[tag_name] = tag_path
		miros.show_tip(tag_name+" 标签添加成功.")
		generate_tags_list()
		#update()

func on_DelBtn_button_down(tag_item:Control):
	var tag_name = tag_item.get_node("TagBtn").text
	tag_resource.Tags.erase(tag_name)
	tag_item.queue_free()
	#update()
	
func on_TagBtn_button_down(tag_item):
	pass

# 保持TagResource
func _on_SaveBtn_button_down():
	ResourceSaver.save(tag_resource,tag_resource.resource_path)
