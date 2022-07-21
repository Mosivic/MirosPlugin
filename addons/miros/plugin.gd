tool
extends EditorPlugin

var Miros = preload("res://addons/miros/core/Miros.tscn").instance()

func _enter_tree():
	get_editor_interface().get_editor_viewport().add_child(Miros)
	make_visible(false)
	Miros.start(self)

func _exit_tree():
	Miros.over()

func has_main_screen():
	return true

func get_plugin_name():
	return "Miros"

func get_plugin_icon():
	return get_editor_interface().get_base_control().get_icon("Tree", "EditorIcons")

func make_visible(visible):
	if Miros:
		Miros.visible = visible

#func handles(object:Object)->bool:
#	if  BTClassDB.is_bt_node(object):
#		return true
#	else:
#		return false


