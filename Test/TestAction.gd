extends Node2D


var action1
var action2
func _ready():
	test1()


func _process(delta):
	action1.execute(delta)


func test1():
	action1 = load("res://addons/miros/module/Action/ActionBase.gd").new("Print")
	action1.set_action(funcref(self,"Print"))
	action1.set_action_args({"name":"Joker"})

func test2():
	action2 =load("res://addons/miros/module/Action/ActionBase.gd").new("PrintTime")
	action2.set_action(funcref(self,"PrintTime"))
	action2.set_start_condition(funcref(self,"startCdt"))
	action2.set_over_condition(funcref(self,"overCdt"))
	action2.set_action_args({"name":"Lay"})

func Print():
	print(action1.actionArgs["name"])
	
func PrintTime():
	print("Action2:Now Time:"+str(OS.get_unix_time()))


func startCdt()->bool:
	if action2.actionLiveTime <2:
		print("Start:livetime:"+str(action2.actionLiveTime))
		return true
	return false

func overCdt()->bool:
	if action2.actionLiveTime <1:
		print("Over:livetime:"+str(action2.actionLiveTime))
		return true
	return false
