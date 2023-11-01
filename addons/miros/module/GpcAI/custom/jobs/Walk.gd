extends GPCAction

var e:CharacterBody2D


func _enter(st,ds):
	var e :CharacterController = ds.get_actor()
	e.play_anim('run')


func _running_physics(delta,st,ds):
	var e :CharacterController = ds.get_actor()
	e.velocity = ds.input_dir * ds.move_speed
	
	if e.velocity != Vector2.ZERO:
		e.spine_sprite.scale = Vector2(-1,1) if e.velocity.x < 0 else Vector2(1,1)
		e.move_and_slide()
	

