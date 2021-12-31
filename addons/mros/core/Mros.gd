extends Node


var sound_manager setget,get_sound_manager
var input_action setget,get_input_action
var input_mgr setget,get_input_mgr
var game_tool setget,get_game_tool
var timeline setget,get_timeline
var save_manager:SavaManager setget,get_save_manager

# 静态加载 - 手动添加
var modules:Dictionary = {
	"SoundManager":[sound_manager,"res://addons/mros/module/Unitool/SoundManager.gd"],
	"InputAction":[input_action,"res://addons/mros/module/Unitool/Input/InputAction.gd"],
	"GameTool":[game_tool,"res://addons/mros/module/Unitool/GameTool.gd"],
	"Timeline":[timeline,"res://addons/mros/module/Timeline/Timeline.gd"],
	"SaveManager":[save_manager,"res://addons/mros/module/Unitool/File/SaveManager.gd"],
}



## 返回模块单例
func get_module(name:String):
	if modules.has(name):
		if modules[name][0] == null:
			var module = load(modules[name][1]).new()
			module.name = name
			add_child(module)
			modules[name][0] = module
			return module
		else:
			return modules[name][0]
	else:
		print("Mros:input module name can't find in modules.")
		return null

func get_input_action():
	return get_module("InputAction") 
	
func get_input_mgr():
	return get_module("InputMgr")
	
func get_sound_manager():
	return get_module("SoundManager") 
	
func get_game_tool():
	return get_module("GameTool")
	
func get_timeline():
	return get_module("Timeline")
	
func get_save_manager():
	return get_module("SaveManager")
