extends Node


# Called when the node enters the scene tree for the first time.
func _ready():

	var ac = DataDriveAccess.bind(self,"res://addons/miros/module/DataDrive/Demo/Resource/human.tres")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
