extends "BTDecoratorBase.gd"



# 反转成功与失败的结果
static func _decorate(e:BTEngine,arg:int,result:int)->int:
	match result:
		e.TASK_STATE.NULL:
			pass
		e.TASK_STATE.SUCCEED:
			result = e.TASK_STATE.FAILED
		e.TASK_STATE.FAILED:
			result = e.TASK_STATE.SUCCEED
		e.TASK_STATE.RUNNING:
			pass
	return result
