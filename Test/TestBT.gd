extends Node2D


var test_graph_data = {
	"LeafAction_934671": {
		"action_name":"",
		"left_nodes_name": ["Root_927116"],
		"name": "LeafAction_934671",
		"offset": Vector2(384, 93),
		"right_nodes_name": ["LeafAction_934713"],
		"type": "LeafAction"
	},
	"LeafAction_934691": {
		"action_name": "",
		"left_nodes_name": ["LeafAction_934713"],
		"name": "LeafAction_934691",
		"offset": Vector2(875, 32),
		"right_nodes_name": [],
		"type": "LeafAction"
	},
	"LeafAction_934713": {
		"action_name":"ActionTimer",
		"left_nodes_name": ["LeafAction_934671"],
		"name": "LeafAction_934713",
		"offset": Vector2(662, 136),
		"right_nodes_name": ["LeafAction_934691"],
		"type": "LeafAction"
	},
	"Root_927116": {
		"action_name":"ActionPrint",
		"left_nodes_name": [],
		"name": "Root_927116",
		"offset": Vector2(100, 83),
		"right_nodes_name": ["LeafAction_934671"],
		"type": "Root"
	}
}


func _ready():
	var engine = load("res://addons/miros/module/BehaviorTree/Util/BTEngine.gd").new(self,test_graph_data,{"time":3})
	engine.set_active(true)
	

