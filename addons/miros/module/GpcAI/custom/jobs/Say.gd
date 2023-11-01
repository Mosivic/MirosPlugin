extends GPCAction

var e:CharacterController

var text_box :Control
var timer := 0.0


func _enter(st,ds):
	var text_box_tscn = preload("res://ui/text box/tesx_box.tscn")
	var e :CharacterController
	var text_box = text_box_tscn.instantiate()
	st['misc']['timer'] = 0.0
	st['misc']['text_box'] = text_box
	
	e.add_child(text_box)
	#text_box.global_position = e.global_position - Vector2(0,220)
	text_box.display_text('是啊啊啊啊啊啊啊啊啊啊啊啊啊啊!!!')


func _running(delta,st,ds):
	st['misc']['timer'] += delta


func _exit(st,ds):
	st['misc']['text_box'].queue_free()


func _is_succeed(st,ds)->bool:
	return st['misc']['timer'] > 1.5


