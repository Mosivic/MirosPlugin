extends WeakRef
class_name  GPCActionsSetting

var _setting := {}

func _init(s:Dictionary) -> void:
	_setting = s

func get_setting():
	return _setting
