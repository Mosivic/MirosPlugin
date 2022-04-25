extends Node2D


export(Resource) var test_res



func _ready():
	var engine = load("res://addons/miros/module/BehaviorTree/Util/BTEngine.gd").new(self,test_res.data,{"time":3})
	engine.set_active(true)
	

