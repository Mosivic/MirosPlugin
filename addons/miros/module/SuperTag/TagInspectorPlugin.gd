extends EditorInspectorPlugin



func can_handle(object):
	return true
	
func parse_begin(object):
	
	
	
	var tags_button = OptionButton.new()
	tags_button.text = "Tags"
	add_custom_control(tags_button)
	
	

