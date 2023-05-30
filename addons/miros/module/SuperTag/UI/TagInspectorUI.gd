@tool
extends VBoxContainer

var miros:Miros
var tags:Dictionary
var node:Node


func init(_miros,_tags:Dictionary,_node:Node):
	miros = _miros
	tags = _tags
	node = _node
	
	for key in tags:
		get_node("AllTags/TagsOption").add_item(key)
	

func _on_AddTag_button_down():
	var tags_option = get_node("AllTags/TagsOption")
	var tag_name = tags_option.get_item_text(tags_option.selected)
	var tags :Array = node.get_meta("tags",[])
	if tags.has(tag_name):
		miros.show_tip(node.name + " 已经存在该标签.")
	else:
		tags.append(tag_name)
		node.set_meta("tags",tags)
		node.add_to_group("Tags",true)
		miros.show_tip(node.name + " 添加标签: "+tag_name)
