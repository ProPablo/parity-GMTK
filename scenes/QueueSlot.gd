extends Node2D

var ITEM_MAX_RANGE = 2 # max items in recipe 
var items = []
onready var global = $"/root/Global"
const Item = preload("res://scenes/Item.tscn")
const Plus = preload("res://scenes/Plus.tscn")
export var space_between = 0.05;
export var expire_time = 2.5

# Called when the node enters the scene tree for the first time.
func _ready():
	var space = $QueueSlotSprite.get_rect().size.x
	var height = $QueueSlotSprite.get_rect().size.y
	var new_item = pick_item();
	var size = new_item.scale * new_item.get_child(0).get_rect().size;
	print((-space/2 + size.x/2 + space*space_between) * -1)
	var queue_scale = get_parent().QUEUE_SCALE;
	var offset =  2 * height * queue_scale
	new_item.position = Vector2(576*0.75, ((-space/2 + size.y/2 + space*space_between) * -1) + offset)
	$QueueSlotSprite.position = Vector2(576*0.75, ((-space/2 + size.y/2 + space*space_between) * -1) + offset)
	$QueueSlotSprite.modulate.a = 1 - 0.16 * queue_scale
	new_item.modulate.a = 1 - 0.16 * queue_scale

	
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
	print("DATA", current_item_data);
#	print("parent" + str(item.get_parent().name))
	item.item_to_queue(current_item_data, $QueueSlotSprite.get_rect().size.y)

	items.append(item);
	print(items)
	return item;

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
