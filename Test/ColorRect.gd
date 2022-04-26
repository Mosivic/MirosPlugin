extends Tree


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var tree = self
	var root = tree.create_item()
	tree.set_hide_root(true)
	var child1 = tree.create_item(root)
	var child2 = tree.create_item(root)
	var subchild1 = tree.create_item(child1)
	subchild1.set_text(0, "Subchild1")


#func get_drag_data(position):
#	var cpb = ColorPickerButton.new()
#	cpb.color = Color.brown
#	cpb.rect_size = Vector2(50, 50)
#	set_drag_preview(cpb)
#	return cpb.color
