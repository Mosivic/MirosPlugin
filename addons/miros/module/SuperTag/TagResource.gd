extends Resource
class_name TagResource

export(Array)  var Tags = ["NULL"]
export(Dictionary) var NodesTag


static func add_tag(tag_name,res:TagResource):
	res.Tags.append(tag_name)
	ResourceSaver.save(res.resource_path,res)
