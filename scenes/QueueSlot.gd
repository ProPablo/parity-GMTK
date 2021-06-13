extends Node2D

signal queue_expire;

var is_expiring = false;
var shake_scalar = 5.0

var ITEM_MAX_RANGE = 2 # max items in recipe 
var items = []
onready var global = $"/root/Global"
const Item = preload("res://scenes/Item.tscn")
const Plus = preload("res://scenes/Plus.tscn")
export var space_between = 0.05;
export var expire_time = 2.5
export var fade_scale = 0.16

var space 
var height 
var parent_size
var index;
var color = Color.white;

var rng


# Called when the node enters the scene tree for the first time.
func _ready():
	space = $QueueSlotSprite.get_rect().size.x * $QueueSlotSprite.scale.x
	height = $QueueSlotSprite.get_rect().size.y * $QueueSlotSprite.scale.y 
	$QueueSlotAnimation.playback_speed = 1 / expire_time;
	parent_size = get_parent().get_rect().size
	
	var item1 = pick_item();
	item1.position.x = -space/4
	
	var item2 = pick_item();
	item2.position.x = space/4
	_start_expiring()
	
	
func _start_expiring():
	is_expiring = true;
	$QueueSlotAnimation.play("Expiring");
	
func _on_slot_expire():
	print("Q dun")
	items = null
	index = 0;
	$QueueSlotSprite.self_modulate = Color(1.0, 1.0, 1.0, 1.0)
	emit_signal("queue_expire")

func adjust_index(index):
	var offset =  height * index + height/2 + space_between * height
	position = Vector2(parent_size.x/2, offset + height*space_between*index)
	var fade = 1 - fade_scale * index
	modulate.a = fade
	
func pick_item() -> KinematicBody2D:

	var item = Item.instance();
	# Very Important to add child to the tree with add_child otherwise it cant access root 
	add_child(item);
#	print("parent" + str(item.get_parent().name))
	var dict_keys = global.asset_dict[global.current_act].keys()
	# var rand_index = rng.randi_range(0, dict_keys.size() - 1)
#	var rand_index = randi() % dict_keys.size()
	var rand_index = randi() % 2
	print("Random shit" + str(rand_index))
	var current_item_name = dict_keys[rand_index]
	var current_item_data = global.asset_dict[global.current_act][current_item_name]
	item.item_to_queue(current_item_data, current_item_name, $QueueSlotSprite.get_rect().size.y)
	
	var size = item.scale * item.get_child(0).get_rect().size;
#	print((-space/2 + size.x/2 + space*space_between) * -1)
	item.position = Vector2(0, 0)
	items.append(item)
	return item;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (!items):
		return
	$QueueSlotSprite.position.x = $QueueSlotAnimation.current_animation_position * shake_scalar * randf(); 
	$QueueSlotSprite.position.y = $QueueSlotAnimation.current_animation_position * shake_scalar * randf();
