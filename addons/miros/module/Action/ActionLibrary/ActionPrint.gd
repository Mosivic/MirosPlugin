extends ActionBase

func _init(arg:Dictionary,refs:WeakRef):
	super(arg,refs)
	action_name = "Print"
	
func _action_process(delta):
	print(action_args["print"])


