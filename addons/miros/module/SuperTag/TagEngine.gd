extends Node

export(Resource) var tag_reource

var tree:SceneTree

var nodes:Array

var tags_map:Dictionary

var tags_object:Dictionary

var tags_effect:Array

func _ready():
	assert(tag_reource != null,"TagEngine:未配置资源文件.")
	
	var tags_data = tag_reource.tags
	for tag in tags_data:
		var tag_script_path = tag_reource.tags[tag]
		var tag_object:TagBase = load(tag_script_path).new()
		tags_object[tag] = tag_object

	tree = get_tree()
	tree.connect("node_added",self,"on_tree_node_added")
	
	nodes = tree.get_nodes_in_group("Tags")
	for node in nodes:
		(node as Node).connect("tree_exited",self,"on_node_tree_exited",[node])
		var tags = node.get_meta("tags",[])
		for tag in tags:
			if tags_map.has(tag):
				tags_map[tag].append(node)
			else:
				tags_map[tag] = [node]
			
			assert(tags_object.has(tag),"TagEngine:资源配置错误,无标签.")
			var tag_object = tags_object[tag]
			if tag_object.positivity == tag_object.POSITIVITY.POSITIVE:
					add_effect(tag,node)
	

func _process(delta):
	handle_effect()

#执行列表中的标签效果
func handle_effect():
	for effect in tags_effect:
		var tag = effect["tag"]
		var node = effect["node"]
		var tag_object:TagBase = tags_object[tag]
		var result = tag_object.effect(self,node)
		
		if tag_object.is_valid() == false:
			remove_effect(effect)

#主动执行标签效果,限定 Positive 和 OneShot
func drive_effect(tag:String,node:Node):
	var tag_object:TagBase = tags_object[tag]
	var result = tag_object.effect(self,node)
	return result

func add_effect(tag:String,node:Node):
	tags_effect.append({
		"tag":tag,
		"node":node
	})

func remove_effect(effect):
	tags_effect.erase(effect)


func on_tree_node_added(node:Node):
	var tags:Array= node.get_meta("tags",[])
	if tags.empty():
		return
	else:
		for tag in tags:
			if tags_map.has(tag):
				tags_map[tag].append(node)
			else:
				tags_map[tag] = [node]
		nodes.append(node)


func on_node_tree_exited(node:Node):
	nodes.erase(node)


func filter(tag:String)->Array:
	var result:= []
	for node in nodes:
		var tags:Array= node.get_meta("tags")
		if tags.has(tag):
			result.append(node)
	return result
