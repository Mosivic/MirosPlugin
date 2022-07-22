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

var positivity = POSITIVITY.NULL
var livelife = LIVELFIE.NULL

var is_valid := true

func _condition(node:Node)->bool:
	return true

func _execute(node:Node):
	pass

func is_valid()->bool:
	return is_valid

func effect(engine,node):
	if not _condition(node): return 
	_execute(node)
	if livelife == LIVELFIE.ONESHOT:
		is_valid = false

