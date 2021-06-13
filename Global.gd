extends Node

var asset_dict = {};
# var inventory_slots = [];

var current_act = "Act1"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	print("Getting assets");
	var json_file = File.new()
	json_file.open("res://assets.json", File.READ)
	asset_dict = JSON.parse(json_file.get_as_text()).result
	# print(asset_dict)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta):
#	pass
