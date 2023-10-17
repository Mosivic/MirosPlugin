extends Node

class_name GoaplLayer


var _layers := {}
var _default_layers := {root = {
	entity = {
		
	},
	virtual = {
		
	}
}}

var _layers_list := []



class Layer:
	var name := ""
	var disable = false
	var action 
	
	func _init(name):
		self.name = name



func _init(layers:Dictionary):
	if layers == {}:
		_layers = _default_layers
	else:
		_layers = layers

#	for _layer in _layers:
#		for key in _layer.keys():
#			var layer = Layer.new(key) 
#			_layers_list.append(layer)
