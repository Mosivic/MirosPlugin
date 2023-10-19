extends Node
class_name GPC


var _actors_ai := {}



func get_actor_property(actor:Node,property_name:String):
	if not _actors_ai.has(actor):
		print("actor not in gpc.")
		return null
		
	var property_sensor:GPCPropertySensor = _actors_ai['property_sensor']
	if not property_sensor.get(property_name):
		print(actor.name + ' not have property that named : ' + property_name)
		return null
	
	return property_sensor.get(property_name)
