extends Node2D
signal queue_expire(queue);

var ITEM_MAX_RANGE = 2 # max items in recipe 
onready var global = $"/root/Global"
onready var main = $"/root/Main"
onready var animator = $Animation
const Item = preload("res://scenes/Item.tscn")
const Plus = preload("res://scenes/Plus.tscn")

export var space_between = 0.05;
export var expire_time = 12.0
export var fade_scale = 0.16
export var shake_scalar = 16.0
export var fire_heart_speed = 2000

var heart_location = Vector2(0,0);

var items = []
var space 
var height 
var parent_size
var index;
var color = Color.white;
var t = 0.0

enum {
	EXPIRING,
	FIRE_AT_HEART,
	CRAFTING,
	FINISHED
}
var state = EXPIRING

var rng
onready var sprite = $Container/Vibrate/QueueSlotSprite
onready var vibrate = $Container/Vibrate

func _ready():
	space = sprite.get_rect().size.x * sprite.scale.x
	height = sprite.get_rect().size.y * sprite.scale.y 
	
	var anim = animator.get_animation("Expiring")
	var anim_distance = global.screen_size.x - space
	anim.track_set_key_value(1, 1, anim_distance)
	
	animator.playback_speed = 1 / expire_time;
	parent_size = get_parent().get_rect().size
	color = Color(randf(), randf(), randf(), 1)
	sprite.get_node("BG").color = color
	sprite.self_modulate = color
	
	var item1 = pick_item();
	item1.position.x = -space/4
	item1.remove_from_group("items")
	
	var item2 = pick_item();
	item2.position.x = space/4
	item2.remove_from_group("items")
	
	_start_expiring()
	
func enable_crafting():
	state = CRAFTING
	animator.stop()
	
func _start_expiring():
	animator.play("Expiring");
	
func _on_queue_expire():
	items = null
#	sprite.modulate = Color(1.0, 1.0, 1.0, 1.0)
#	$Container/BG.color = Color(1.0, 1.0, 1.0, 1.0)
	state = FIRE_AT_HEART
#	$Tween.interpolate_property(self, "position", position, move_to, time_to_craft, Tween.TRANS_LINEAR)
#	$Tween.start()
	emit_signal("queue_expire", self)
	

func adjust_index(index):
	var offset =  height * index + height/2 + space_between * height
	position = Vector2(parent_size.x/2, offset + height*space_between*index)
	var fade = 1 - fade_scale * index
	modulate.a = fade
	
func pick_item() -> KinematicBody2D:
	var item = Item.instance();
	# Very Important to add child to the tree with add_child otherwise it cant access root 
#	$Container.add_child(item)
	vibrate.add_child(item)
	var dict_keys = global.asset_dict[global.current_act].keys()
	var rand_index = randi() % dict_keys.size()
#	var rand_index = randi() % 2
	var current_item_name = dict_keys[rand_index]
	var current_item_data = global.asset_dict[global.current_act][current_item_name]
	item.item_to_queue(current_item_data, current_item_name, sprite.get_rect().size.y)
	
	var size = item.scale * item.get_child(0).get_rect().size;
	item.position = Vector2(0, 0)
	items.append(item)
	return item;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	match state:
		CRAFTING:
			pass
		EXPIRING:
			vibrate.position.y = animator.current_animation_position * shake_scalar * randf();
			vibrate.position.x = animator.current_animation_position * shake_scalar * randf(); 
		FIRE_AT_HEART:
			global_position += Vector2(0, fire_heart_speed * delta);


func _on_QueueSlot_area_entered(area):
	print("Found heart")
	main.life_down()
	queue_free()
	pass # Replace with function body.


func _on_QueueSlot_body_entered(body):
	print("found package")
	body.queue_free()
	pass # Replace with function body.
