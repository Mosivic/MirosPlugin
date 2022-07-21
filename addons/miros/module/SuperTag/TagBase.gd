extends Reference
class_name TagBase

enum POSITIVITY{
	NULL,
	POSITIVE,
	NEGATIVE,
}

enum LIVELFIE{
	NULL,
	ONESHOT,
	REPEAT,
}

var tag_name:String
var positivity = POSITIVITY.NULL
var livelife = LIVELFIE.NULL

var is_valid := true

func _condition(object:Object)->bool:
	return true

func _execute(object:Object):
	pass

func is_valid()->bool:
	return is_valid

func effect(engine,object:Object):
	if not _condition(object): return 
	_execute(object)
	if livelife == LIVELFIE.ONESHOT:
		is_valid = false

