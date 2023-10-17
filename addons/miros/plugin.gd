@tool
extends EditorPlugin

var Miros = preload("res://addons/miros/core/Miros.tscn")
var MiroIcon = preload("res://addons/miros/resource/Image/delete.svg")

var _miros:Control = null


func _enter_tree():
	_miros = Miros.instantiate()
	var _miros_name = "Miros"
	get_editor_interface().get_editor_main_screen().add_child(_miros)
	
	_miros.start(self)
	_make_visible(false)
	

func _exit_tree():
	_miros.over()
	pass

func  _has_main_screen():
	return true

func _get_plugin_name():
	return "Miros"

#func _get_plugin_icon():
#	return MiroIcon

func _make_visible(visible):
	if _miros:
		_miros.visible = visible


#func handles(object:Object)->bool:
#	if  BTClassDB.is_bt_node(object):
#		return true
#	else:
#		return false


