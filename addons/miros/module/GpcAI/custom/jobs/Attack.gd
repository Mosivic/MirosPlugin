extends GPCAction


func _enter(st,ds):
	var e :CharacterController = ds.get_actor()
	e.play_anim('attack',false)
	e.hit_box.set_deferred('disabled',false)
	
	print("Attak!!!!")


func _exit(st,ds):
	var e :CharacterController = ds.get_actor()
	e.hit_box.set_deferred('disabled',true)


func _is_succeed(st,ds)->bool:
	var e :CharacterController = ds.get_actor()
	return e.is_anim_complete()

