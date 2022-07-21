tool
extends VBoxContainer

var tags:Array
var object:Object


func init(_tags:Array,_object:Object):
	tags = _tags
	object = _object
	
	for tag in tags:
		get_node("AllTags/TagsOption").add_item(tag)
	


func _on_AddTag_button_down():
	var tags_option = get_node("AllTags/TagsOption")
	var tag_name = tags_option.get_item_text(tags_option.selected)
	var tags :Array = object.get_meta("tags",[])
	if tags.has(tag_name):
		pass
	else:
		tags.append(tag_name)
	object.set_meta("tags",tags)
	(object as Node).add_to_group("Tags",true)
