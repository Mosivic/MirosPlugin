# 
# 
#
extends Reference

enum ACTION_TYPE{
	NULL,
	SLOT,
	LOOP,
}

enum ACTION_STATE{
	NULL,
	PREPARE,
	RUNNING,
	SUCCESS,
	FAILED,
}

var actionName: String
var actionType = ACTION_TYPE.NULL
var actionState = ACTION_STATE.NULL
var actionStartCondition:FuncRef setget set_start_condition
var actionOverCondition:FuncRef setget set_over_condition
var actionFunc:FuncRef
var actionArgs:Dictionary setget set_action_args
var actionLiveTime:float
var currentTime:float = 0


func _init(name:String,live_time:float=1,type=1,args:Dictionary={}):
	build(name,live_time,type,args)


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
	self.actionFunc = funcref(self,"_action")
	self.actionLiveTime = live_time
	self.actionState = ACTION_STATE.PREPARE
	

func _action():
	return

func _start_condition()->bool:
	return true
	
func _over_condition()->bool:
	return true

# 执行Action,返回Action状态
func execute(delta)->int:
	# 如果动作生命时长结束，则结束, actionLiveTime初始值设置为-1时生命时长无限
	if !currentTime == -1:
		currentTime += delta
	if currentTime >= actionLiveTime: 
		actionState = ACTION_STATE.FAILED
	# 如果动作执行完毕，则结束
	if actionState == ACTION_STATE.SUCCESS or actionState == ACTION_STATE.FAILED:
		return actionState

	if actionType == ACTION_TYPE.SLOT: # 单次Action
		actionState = ACTION_STATE.RUNNING
		actionFunc.call_func()
		actionState = ACTION_STATE.SUCCESS
	elif actionType == ACTION_TYPE.LOOP: # 循环Action
		if actionState == ACTION_STATE.PREPARE: # 如果准备执行，则执行
			if actionStartCondition == null: # 如果没有设置开始条件，则直接执行
				actionState = ACTION_STATE.RUNNING
			else:
				if actionStartCondition.call_func() == true: # 如果开始条件成立，则执行
					actionState = ACTION_STATE.RUNNING 
				else:
					actionState = ACTION_STATE.PREPARE
		elif actionState == ACTION_STATE.RUNNING: # 如果正在执行，则继续执行
			if actionOverCondition == null: # 如果没有设置结束条件，则直接结束
				actionFunc.call_func()
				actionState = ACTION_STATE.SUCCESS
			else: 
				if actionOverCondition.call_func() == true: # 如果结束条件成立，则结束
					actionState = ACTION_STATE.SUCCESS
				else: # 如果结束条件不成立，则继续执行
					actionFunc.call_func()
	# 返回动作状态
	return actionState
	
func set_action_args(args:Dictionary):
	actionArgs = args

func set_action(_action:FuncRef):
	actionFunc = _action

func set_start_condition(condition:FuncRef):
	actionStartCondition = condition

func set_over_condition(condition:FuncRef):
	actionOverCondition = condition

func reset():
	currentTime = 0
	actionState = ACTION_STATE.PREPARE

