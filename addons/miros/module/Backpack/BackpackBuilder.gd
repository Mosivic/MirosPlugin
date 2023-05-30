# Backpack Builder
# 背包生成器
# 指定custom_slot路径
# 指定Backpack宿主，需要为PannelContainer类型，且没有子结点
# 将BackpackBase.gd脚本或其子类挂载在Backpack宿主上
# 指定Backpack.gd的资源res
# 设置好在Inspecter中本生成器的参数，点击生成
# 启动场景OK！
@tool
extends Node

# 自定义Slot需要为Control基类型
@export var custom_slot:PackedScene:set=set_custom_slot

@export var slot_columns:int = 8
@export var slot_raws:int = 8
@export var slot_size:Vector2 = Vector2(32,32)

@export var backpack_path:NodePath 

@export var generate:bool:set=set_generate
@export var clear:bool:set=set_clear



func set_generate(v):
	var backpack = get_node(backpack_path)
	if backpack == null or !backpack is PanelContainer:
		return
	if backpack.get_child_count() != 0:
		return
	generate_backpack(backpack)
	generate_slots(backpack)

func set_clear(v):
	var backpack = get_node(backpack_path)
	if backpack == null or !backpack is PanelContainer:
		return
	for child in backpack.get_children():
		child.queue_free()
		
func set_custom_slot(v):
	custom_slot = v

func generate_backpack(_backpack:Node):
	var container = GridContainer.new()
	container.name = "GridContainer"
	_backpack.add_child(container)
	container.set_owner(get_tree().get_edited_scene_root())

func generate_slots(_backpack:Node):
	var container = _backpack.get_node("GridContainer")
	container.columns = slot_columns
	for child in container.get_children():
		child.queue_free()
	
	var total_count = slot_raws * slot_columns
	for i in total_count:
		var slot = custom_slot.instance()
		slot.rect_size = slot_size
		container.add_child(slot)
		slot.set_owner(get_tree().get_edited_scene_root())
