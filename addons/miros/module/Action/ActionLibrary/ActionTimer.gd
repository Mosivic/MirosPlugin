###
# 暂时器Action  By Mosiv 2022.04.23
# 需要传入参数time，指定暂停时间
###
extends ActionBase

func _init(arg:Dictionary,refs:WeakRef):
	super(arg,refs)
	action_name = "Timer"
	
func _over_condition()->bool:
	if current_time >= action_args["time"]:
		print("Timer:had run time: "+ str(current_time))
		return true
	return false
