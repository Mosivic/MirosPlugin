extends TagBase

func _init():
	positivity = POSITIVITY.POSITIVE
	livelife = LIVELFIE.ONESHOT
	
func _execute(node:Node):
	print(node.name + " :Say Hello!")
