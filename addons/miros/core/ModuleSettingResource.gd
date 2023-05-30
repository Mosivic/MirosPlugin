extends Resource
class_name ModuleSettingResource

@export var name:String
@export_file("*.gd") var core
@export var is_open:bool
@export_file("*.gd") var inspector_plugin
@export_file("*.tscn")  var setting_panel 
@export var version:String
@export var extra:Dictionary
@export_multiline var introdution


