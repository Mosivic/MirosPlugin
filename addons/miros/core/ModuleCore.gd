extends Node
class_name ModuleCore

var plugin:EditorPlugin
var setting:ModuleSettingResource

func init(_plugin,_setting):
	plugin = _plugin
	setting = _setting

func start():
	pass
	
func over():
	pass

func save():
	ResourceSaver.save(setting,setting.resource_path)


