extends CharacterBody2D


@export var test_res:Resource


func _ready():
	var action_refs = Blackboard.new()
	action_refs.data["actor"] = self
	var engine_class:GDScript = load("res://addons/miros/module/BehaviorTree/Util/BTEngine.gd")
	var engine = engine_class.new(test_res.data,action_refs)
	engine.set_active(true)
	
	print(self)

#	add_hp()
#	add_hp_zero_trigger()
#	add_buff_poison()
#	add_buff_hp_mutiply()
	
#How to use OneData
# 添加一个血量降为0的触发器，触发hp_zero_call()函数
func add_hp_zero_trigger():
	var one_data = get_node("OneData")
	one_data.add_property_trigger("Hp reduce to zero","hp",0,1,Callable(self,"hp_zero_call"))

func hp_zero_call():
	print("I am dead!")
	var one_data = get_node("OneData")
	one_data.remove_property_trigger("Hp reduce to zero")

#直接加血量
func add_hp():
	var one_data = get_node("OneData")
	one_data.caculate_property("hp",10)

#自身添加一个持续30s，每1秒触发减血量5点的buff，buff结束后调用poison_over()函数
func add_buff_poison():
	var one_data = get_node("OneData")
	one_data.add_buff("poison","hp",-5,0.5,30,1,Callable(self,"poison_on"),Callable(self,"poison_over"))

func poison_on():
	print("I am poisoning,help me!")

func poison_over():
	print("Ok gays my poison over!")


#自身添加一个常驻，每1s血量变为原来的1.05倍的buff
func add_buff_hp_mutiply():
	var one_data = get_node("OneData")
	one_data.add_buff("god hp","hp",1.05,1,-1,2)
