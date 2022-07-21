tool
extends ModuleCore

var inspector_plugin:EditorInspectorPlugin

func start():
	inspector_plugin = load(setting.inspector_plugin).new()
	inspector_plugin.init(setting)
	plugin.add_inspector_plugin(inspector_plugin)
	
func over():
	plugin.remove_inspector_plugin(inspector_plugin)

