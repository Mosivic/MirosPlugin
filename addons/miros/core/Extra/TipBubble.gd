tool
extends ColorRect

func show_tip(text:String):
	get_node("Label").text = text
	
	var tween = get_tree().create_tween()

	tween.tween_callback(self,"show")
	tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback(get_node("Label"),"hide")
	tween.tween_property(self,"color:a",1.0,0.3)
	tween.tween_callback(get_node("Label"),"show")
	
	tween.tween_property(self,"color:a",0.0,2.0)
	tween.tween_callback(self,"hide")
