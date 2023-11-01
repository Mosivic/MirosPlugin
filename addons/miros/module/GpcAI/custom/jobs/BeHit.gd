extends GPCAction

var tween:Tween
var knockback
var timer := 0.0

var e:CharacterController


func _enter(st,ds):
	var e :CharacterController = ds.get_actor()
	st['misc']['timer'] = 0.0
	e.play_anim("idle-from fall")

	print('behit')


func _running_physics(delta,st,ds):
	var e :CharacterController = ds.get_actor()
	st['misc']['timer'] += delta
	
	e.velocity = ds.be_attack_dir * 500
	#actor.velocity += knockback
	e.move_and_slide()


func _is_succeed(st,ds)->bool:
	return st['misc']['timer'] > 0.4

