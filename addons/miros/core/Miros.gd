@tool
extends Control
class_name Miros

var plugin :EditorPlugin
var module_item_tscn = preload("res://addons/miros/core/ModuleItem.tscn")

var tip_bubble_tscn = preload("res://addons/miros/core/Extra/TipBubble.tscn")
var tip_bubble

var tabs_map:Dictionary 
var tabs_index := 0


#如果需要添加模块
#1.新建一个模块设置资源文件（ModuleSettingResource）
#2.添加该资源文件路径至下面
const Modules = [
	"res://addons/miros/module/BehaviorTree/BTGraphSettingResource.tres",
	"res://addons/miros/module/SuperTag/SuperTagSettingResource.tres"
]

# 开始,加载界面生成模块
func start(_plugin:EditorPlugin):
	plugin = _plugin
	for module in Modules:
		var setting :ModuleSettingResource = load(module)
		var module_item = module_item_tscn.instantiate()
		module_item.get_node("NameLabel").text = setting.name
		module_item.get_node("Setting").button_down.connect(on_ModuleSetting_button_down.bind(setting))
		module_item.get_node("Switch").toggled.connect(on_ModuleSwitch_toggled.bind(setting))
		get_node("Tabs/Center/VBoxContainer").add_child(module_item)
		
		if setting.is_open:
			module_item.get_node("Switch").pressed = true #注意, 该代码会调动Swith的绑定事件"on_ModuleSwitch_toggled"
	
	tip_bubble = tip_bubble_tscn.instance()
	plugin.get_editor_interface().add_child(tip_bubble)

	
# 结束所有模块,销毁自身
func over():
	plugin.get_editor_interface().remove_child(tip_bubble)

	var modules = get_node("Modules").get_children()
	for core in modules:
		core.over()
		core.save()
		core.queue_free()
	queue_free()

func create_module(setting:ModuleSettingResource):
	if get_node("Modules").find_node(setting.name) != null:return
	var core = load(setting.core).new()
	core.init(plugin,setting)
	core.name = setting.name
	setting.is_open = true
	get_node("Modules").add_child(core)
	core.start()

func destory_module(setting:ModuleSettingResource):
	setting.is_open =false
	var core = get_node("Modules").find_node(setting.name)
	if core:
		core.over()
		core.save()
		core.queue_free()

#模块开关按钮按下
func on_ModuleSwitch_toggled(button_pressed,setting:ModuleSettingResource):
	if button_pressed:
		create_module(setting)
	else:
		destory_module(setting)
		

#模块设置按钮按下,创建并打开模块设置页面
func on_ModuleSetting_button_down(setting:ModuleSettingResource):
	if setting.setting_panel == "":return
	
	var tabs := get_node("Tabs") as TabContainer
	var setting_panel_name = setting.name + "SettingPanel"

	if  tabs_map.has(setting_panel_name):
		pass
	else:
		tabs_index = tabs_index + 1
		tabs_map[setting_panel_name] = tabs_index
		var setting_panel = load(setting.setting_panel).instance()
		tabs.add_child(setting_panel)
		setting_panel.init(self,setting)
	tabs.set_current_tab(tabs_map[setting_panel_name]) 
	#update()


func show_tip(text:String):
	tip_bubble.show_tip(text)

