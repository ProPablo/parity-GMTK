extends Node2D

signal queue_expire(index);

var is_expiring = false;
var shake_scalar = 5.0

var ITEM_MAX_RANGE = 2 # max items in recipe 
var items = []
onready var global = $"/root/Global"
const Item = preload("res://scenes/Item.tscn")
const Plus = preload("res://scenes/Plus.tscn")
export var space_between = 0.05;
export var expire_time = 5.0
export var fade_scale = 0.16

var heart_location = Vector2(0,0);

var space 
var height 
var parent_size
var index;
var color = Color.white;
var fire_at_heart = false
var t = 0.0
var fire_heart_speed = 10

enum {
	MOVING,
	FIRE_AT_HEART,
	CRAFTING,
	FINISHED
}
var state = MOVING

var rng
onready var sprite = $Container/QueueSlotSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	space = sprite.get_rect().size.x * sprite.scale.x
	height = sprite.get_rect().size.y * sprite.scale.y 
	$QueueSlotAnimation.playback_speed = 1 / expire_time;
	parent_size = get_parent().get_rect().size
	
	color = Color(randf(), randf(), randf(), 1)
	sprite.self_modulate = color
	
	var item1 = pick_item();
	item1.position.x = -space/4
	
	var item2 = pick_item();
	item2.position.x = space/4
	_start_expiring()
	
func enable_crafting():
	$QueueSlotAnimation.stop()
	
func _start_expiring():
	is_expiring = true;
	$QueueSlotAnimation.play("Expiring");
	
func _on_slot_expire():
	
	print("Q dun")
	items = null
	index = 0;
	sprite.self_modulate = Color(1.0, 1.0, 1.0, 1.0)
	fire_at_heart = true
	emit_signal("queue_expire", index)

func adjust_index(index):
	var offset =  height * index + height/2 + space_between * height
	position = Vector2(parent_size.x/2, offset + height*space_between*index)
	var fade = 1 - fade_scale * index
	modulate.a = fade
	
func pick_item() -> KinematicBody2D:

	var item = Item.instance();
	# Very Important to add child to the tree with add_child otherwise it cant access root 
	$Container.add_child(item)
#	sprite.add_child(item);
#	print("parent" + str(item.get_parent().name))
	var dict_keys = global.asset_dict[global.current_act].keys()
	# var rand_index = rng.randi_range(0, dict_keys.size() - 1)
#	var rand_index = randi() % dict_keys.size()
	var rand_index = randi() % 2
	var current_item_name = dict_keys[rand_index]
	var current_item_data = global.asset_dict[global.current_act][current_item_name]
	item.item_to_queue(current_item_data, current_item_name, sprite.get_rect().size.y)
	
	var size = item.scale * item.get_child(0).get_rect().size;
#	print((-space/2 + size.x/2 + space*space_between) * -1)
	item.position = Vector2(0, 0)
	items.append(item)
	return item;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match state:
		CRAFTING:
			pass
		MOVING:
			sprite.position.y = $QueueSlotAnimation.current_animation_position * shake_scalar * randf();
			sprite.position.x = $QueueSlotAnimation.current_animation_position * shake_scalar * randf(); 
		FIRE_AT_HEART:
			var vect = (global_position - heart_location).normalized();
			global_position += vect * fire_heart_speed * delta;	


func _on_QueueSlot_area_entered(area):
	print("Found heart")
	pass # Replace with function body.


func _on_QueueSlot_body_entered(body):
	print("found package")
	body.queue_free()
	pass # Replace with function body.
