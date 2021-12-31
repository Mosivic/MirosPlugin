extends Node


## 任务执行结果
enum{
	NULL,
	SUCCEED, # 执行成功
	FAILED, # 执行失败
	RUNNING, # 执行中
}

var root # 根节点
var actor # 控制的节点
var task_idx = 0 # 当前执行task的index

## 节点的任务
func _task()->int:
	return SUCCEED

	
	
