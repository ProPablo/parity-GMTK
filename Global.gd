extends Node
var asset_dict = {};
# var inventory_slots = [];

var current_act = "Act_1"
var screen_size;

# Called when the node enters the scene tree for the first time.
func _ready():
	if OS.get_name() == "Windows" && !OS.is_debug_build():
		OS.set_window_position(Vector2())
#	var projectResolution=Vector2(Globals.get("display/width"),Globals.get("display/height"));
#	print(OS.window_size)
#	print(ProjectSettings.get_setting("display/window/size/width"))
	screen_size = Vector2(ProjectSettings.get_setting("display/window/size/width"), ProjectSettings.get_setting("display/window/size/height"))
#	screen_size = get_viewport().size;
	print("Getting assets");
	var json_file = File.new()
	json_file.open("res://assets.json", File.READ)
	asset_dict = JSON.parse(json_file.get_as_text()).result
	# print(asset_dict)
	pass # Replace with function body.

func next_act():
	var current_act_split = current_act.split("_")
	var act = int(current_act_split[1]) 

	
	var num_acts = asset_dict.keys()
	if (act == num_acts.size()):
		get_tree().change_scene("res://scenes/EndMenu.tscn")
		return
	current_act = current_act_split[0] + "_" + str(int(act + 1))
	get_tree().reload_current_scene()
	
