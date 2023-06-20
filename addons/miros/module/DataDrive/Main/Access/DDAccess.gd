extends Node
class_name DataDriveAccess


var storage:DataDriveStorage = DataDriveStorage.new()


func bind(entity:Node,template_path:String):
	var template = ResourceLoader.load(template_path)
	storage.into(template)



class DataDriveStorage extends  WeakRef:

	func into(res:Resource):
		var property_kv := []
		var property_list := res.get_property_list()

		for property in property_list:
			var key = property["name"]
			var value := res.get(key)
			property_kv.append({ "name": key, "value": value })


