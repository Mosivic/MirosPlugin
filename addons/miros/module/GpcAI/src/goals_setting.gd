extends WeakRef
class_name  GPCGoalsSetting

var _setting := {}

func _init(s:Dictionary) -> void:
	_setting = s

func get_setting():
	return _setting
