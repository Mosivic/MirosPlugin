# ActionBase
# By Mosiv 2022.4.30

extends WeakRef
class_name ActionBase

var action_state:int = 0

var action_name: String

var action_args:Dictionary 
var action_temp:Dictionary
var action_refs:WeakRef

var action_process:Callable
var action_physics_process:Callable

var action_start_condition:Callable 
var action_over_condition:Callable
var action_continue_condition:Callable

var current_time:float = 0
var execute_count:int = 0


func _init(arg:Dictionary,refs:WeakRef):
	self.action_args = arg
	self.action_refs = refs
	self.action_process = Callable(self,"_action_process")
	self.action_physics_process = Callable(self,"_action_physics_process")
	self.action_start_condition = Callable(self,"_start_condition")
	self.action_over_condition = Callable(self,"_over_condition")
	self.action_continue_condition = Callable(self,"_continue_condition")


# 在执行前准备
func _before_execute():
	pass

# 在执行后收尾
func _after_execute():
	pass

# 开始执行的条件
func _start_condition()->bool:
	return true
	
# 继续执行的条件
func _continue_condition()->bool:
	return true

# 结束执行的条件	
func _over_condition()->bool:
	return true

# 执行动作 物理帧
func _action_physics_process(delta):
	return

# 执行动作 正常帧率
func _action_process(delta):
	pass

func Execute_before():
	_before_execute()

func Execute_after():
	_after_execute()

# 执行
func Execute(delta:float,is_physics:bool):
	match is_physics:
		true:
			action_physics_process.call(delta)
		false:
			current_time += delta 
			action_process.call(delta)
	execute_count += 1


func Is_can_execute()->bool:
	return action_start_condition.call()

func Is_over_execute()->bool:
	return action_over_condition.call()

func Is_continue_execute()->bool:
	return action_continue_condition.call()

func Set_action_args(v:Dictionary):
	action_args = v

func Set_action_refs(v:WeakRef):
	action_refs = v

func Set_start_condition(condition:Callable):
	action_start_condition = condition

func Set_over_condition(condition:Callable):
	action_over_condition = condition
	
func Set_continue_condition(condition:Callable):
	action_continue_condition = condition

func Set_process(process:Callable):
	action_process = process

func Set_physics_process(physics_process:Callable):
	action_physics_process = physics_process 

func Reset():
	action_temp.clear()
	action_state = 0
	current_time = 0
	execute_count = 0

func Set_state(v):
	action_state = v

func Get_state():
	return action_state


