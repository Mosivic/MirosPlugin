# 
# 
#
extends Reference

enum ACTION_TYPE{
	NULL,
	SLOT,
	LOOP,
	TIMES,
}

const ACTION_STATE={
	NULL = -1,
	PREPARE = 1,
	RUNNING = 2,
	SUCCEED = 3,
	FAILED = 0,
}


var actionName: String
var actionType = ACTION_TYPE.NULL

var actionStartCondition:FuncRef setget set_start_condition
var actionOverCondition:FuncRef setget set_over_condition
var actionArgs:Reference setget set_action_args
var actionLiveTime:float
var currentTime:float = 0

var actionState = ACTION_STATE.NULL
var actionStateProcess = ACTION_STATE.NULL
var actionStatePhysicsProcess = ACTION_STATE.NULL

func _init(name:String,live_time:float=1,type:int=1):
	build(name,live_time,type)

# 构建Action
# @param actionName:动作名称
# @param actionType:动作类型   
# @param actionStartCondition:动作开始条件
# @param actionOverCondition:动作结束条件
# @param actionFunc:动作函数
# @param actionArgs:动作参数
# @param actionLiveTime:动作生命周期
func build(name:String,live_time:float=1,type:int=1,args:Dictionary={}):
	self.actionName = name
	self.actionType = type
	self.actionStartCondition = funcref(self,"_start_condition")
	self.actionOverCondition = funcref(self,"_over_condition")
	self.actionLiveTime = live_time
	self.actionState = ACTION_STATE.PREPARE
	self.actionStateProcess = ACTION_STATE.PREPARE
	self.actionStatePhysicsProcess = ACTION_STATE.PREPARE

func _start_condition()->bool:
	return true
	
func _over_condition()->bool:
	return true

func _action_physics_process(delta):
	return

func _action_process(delta):
	pass

func get_state()->int:
	if actionStateProcess * actionStatePhysicsProcess == 9:
		return ACTION_STATE.SUCCEED
	elif actionStateProcess * actionStatePhysicsProcess == 0:
		return ACTION_STATE.FAILED
	elif actionStateProcess * actionStatePhysicsProcess == 1:
		return ACTION_STATE.PREPARE
	else:
		return ACTION_STATE.RUNNING

func execute_physics_process(delta):
	actionStatePhysicsProcess = _execute(delta,funcref(self,"_action_physics_process"),actionStatePhysicsProcess,true)


func execute_process(delta):
	actionStateProcess = _execute(delta,funcref(self,"_action_process"),actionStateProcess,false)
	

# 执行Action,返回Action状态
func _execute(delta,_actionFunc:FuncRef,state,is_physics:bool)->int:
	# 如果动作生命时长结束，则结束, actionLiveTime初始值设置为-1时生命时长无限
	# 在_process中判断
	if !is_physics:
		currentTime = delta + currentTime
		if actionLiveTime == -1:
			pass
		else:
			if currentTime >= actionLiveTime: 
				state = ACTION_STATE.FAILED
	# 如果动作执行完毕，则结束
	if state == ACTION_STATE.SUCCEED or state == ACTION_STATE.FAILED:
		return state

	if actionType == ACTION_TYPE.SLOT: # 单次Action
		state = ACTION_STATE.RUNNING
		_actionFunc.call_func(delta)
		state = ACTION_STATE.SUCCEED
	elif actionType == ACTION_TYPE.LOOP: # 循环Action
		if state == ACTION_STATE.PREPARE: # 如果准备执行，则执行
			if actionStartCondition == null: # 如果没有设置开始条件，则直接执行
				state = ACTION_STATE.RUNNING
			else:
				if actionStartCondition.call_func() == true: # 如果开始条件成立，则执行
					state = ACTION_STATE.RUNNING 
				else:
					state = ACTION_STATE.PREPARE
		elif state == ACTION_STATE.RUNNING: # 如果正在执行，则继续执行
			if actionOverCondition == null: # 如果没有设置结束条件，则直接结束
				_actionFunc.call_func(delta)
				state = ACTION_STATE.SUCCEED
			else: 
				if actionOverCondition.call_func() == true: # 如果结束条件成立，则结束
					state = ACTION_STATE.SUCCEED

				else: # 如果结束条件不成立，则继续执行
					_actionFunc.call_func(delta)
					state = ACTION_STATE.RUNNING
	# 返回动作状态
	return state



func set_action_args(v:Reference):
	actionArgs = v

func set_start_condition(condition:FuncRef):
	actionStartCondition = condition

func set_over_condition(condition:FuncRef):
	actionOverCondition = condition

func reset():
	currentTime = 0
	actionState = ACTION_STATE.PREPARE
	actionStateProcess = ACTION_STATE.PREPARE
	actionStatePhysicsProcess = ACTION_STATE.PREPARE

