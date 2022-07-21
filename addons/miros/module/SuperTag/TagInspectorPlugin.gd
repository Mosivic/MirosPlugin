extends EditorInspectorPlugin

var setting:ModuleSettingResource
var tags:Array

var inspector_tscn = preload("res://addons/miros/module/SuperTag/UI/TagInspectorUI.tscn")

func init(_setting:ModuleSettingResource):
	setting = _setting

func can_handle(object):
	return true
	
func parse_begin(object):
	if setting.extra.has("tag_resource_path"):
		tags = load(setting.extra["tag_resource_path"]).tags
		
	if tags.empty():
		var label = Label.new()
		label.text = "No Tag"
		add_custom_control(label)
	else:
		generate_inspector(object)
	
func generate_inspector(object):

	var inspector = inspector_tscn.instance()
	inspector.init(tags,object)
	add_custom_control(inspector)


