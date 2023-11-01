extends GPCAction

var e :CharacterController


func _enter(st,ds):
	e = ds.get_actor()
	e.play_anim('walk')


func _running_physics(delta,st,ds):
	var move_dir:= Vector2.ZERO
	
	if ds.move_dir.x > 0:
		move_dir = Vector2.ZERO.direction_to(Vector2(1,-1))
	elif ds.move_dir.x < 0:
		move_dir = Vector2.ZERO.direction_to(Vector2(-1,1))
	
		
	e.velocity = ds.move_dir * ds.move_speed
	
	e.spine_sprite.scale  = Vector2(-1,1) if e.velocity.x < 0 else Vector2(1,1)
	e.move_and_slide()
