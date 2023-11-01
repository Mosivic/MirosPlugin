extends GPCAction


func _enter(st,ds):
	var e :CharacterController = ds.get_actor()
	e.play_anim('idle')


