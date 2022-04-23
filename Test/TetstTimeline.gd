### 时间轴系统测试 - OK
extends Node2D

func _ready():
	test()


func test():
	var timelineMgr = Miros.GetTimelineManager()
	var actionMgr = Miros.GetActionManager()
	var timeline = load("res://addons/miros/module/Timeline/TImeline.gd").new()
	var action1 = load("res://addons/miros/module/Action/ActionBase.gd").new("test2")
	var action2 = load("res://addons/miros/module/Action/ActionBase.gd").new("test3")
	var action3 = load("res://addons/miros/module/Action/ActionBase.gd").new("test4")
	var action4 = load("res://addons/miros/module/Action/ActionBase.gd").new("test1")
	var action5 = load("res://addons/miros/module/Action/ActionLibrary/ActionPrint.gd").new("test5")
	action1.set_action(funcref(self,"Print1"))
	action2.set_action(funcref(self,"Print2"))
	action3.set_action(funcref(self,"Print3"))
	action4.set_action(funcref(self,"Print4"))
	timeline.AddStampAuto(1,action1)
	timeline.AddStampAuto(3,action2)
	timeline.AddStampAuto(3.5,action3)
	timeline.AddStampAuto(5,action4)
	timeline.AddStampAuto(6,action5)
	timelineMgr.AddTimeline("test",timeline)
	timelineMgr.RunTimeline("test")
	
	
	


func Print1():
	print("测试1")

func Print2():
	print("测试2")

func Print3():
	print("测试3")

func Print4():
	print("测试4")



