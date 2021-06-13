extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var items = []
onready var global = $"/root/Global"
const Item = preload("res://scenes/Item.tscn")
const Plus = preload("res://scenes/Plus.tscn")
export var space_between = 0.05;

# Called when the node enters the scene tree for the first time.
func _ready():
	var space = $QueueSlotSprite.get_rect().size.x
	var new_item = pick_item();
	var size = new_item.scale * new_item.get_child(0).get_rect().size;
	new_item.position = Vector2(-space/2 + size.x/2 + space*space_between, 0)
	
	
	pass # Replace with function body.

func pick_item() -> KinematicBody2D:
	var dict_keys = global.asset_dict[global.current_act].keys()
	var rand_index = rand_range(0, dict_keys.size() - 1)
	print(rand_index)
	
	var current_item_name = dict_keys[rand_index]
	var current_item_data = global.asset_dict[global.current_act][current_item_name]
	var item = Item.instance();
	# Very Important to add child to the tree with add_child otherwise it cant access root 
	add_child(item);
#	print("parent" + str(item.get_parent().name))
	item.item_to_queue(current_item_data, $QueueSlotSprite.get_rect().size.y)

	items.append(item);
	return item;

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
