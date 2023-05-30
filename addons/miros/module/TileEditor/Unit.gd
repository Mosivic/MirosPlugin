extends Node2D


@export var pos_unit:Vector3:set=set_pos_unit
## 单位类型
@export var type:int

func set_pos_unit(value:Vector3):
	var GameTool = load("res://addons/miros/core/Miros.gd").GetGameTool()
	pos_unit = value
	position = GameTool.unit_to_cartesian(value)



func _enter_tree():
	var unitManager = load("res://addons/miros/core/Miros.gd").GetUnitManager()
	unitManager.register_unit(type,self)


func _exit_tree():
	var unitManager = load("res://addons/miros/core/Miros.gd").GetUnitManager()
	unitManager.unregister_unit(type,self)
