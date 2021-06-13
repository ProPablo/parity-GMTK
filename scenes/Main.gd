extends Node2D
export (PackedScene) var Item;
const Slot = preload("res://scenes/Slot.tscn")
const QueueSlot = preload("res://scenes/QueueSlot.tscn")
onready var global = $"/root/Global"
#Stays constant thanks to settings
var screen_size;
export var queue_slots = 6;
export var total_slots = 4;
export var slots_margin = 0.3;

#var inventory = []
var queue = []
var slots = []

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size;
	$ItemTimer.start();
	$QueueTimer.start();
	$Player.connect("item_collected", self, "_on_Item_pickup")
	# slots.append($HUD/InventoryHUD/InventorySlot1)
	print(slots)
	create_inventory()
	pass # Replace with function body.

func create_inventory():
	var hud_size = $HUD/InventoryHUD.get_rect().size
	# if div_x - slot_size - margin/2 is negative, adjust the scale of slot to adjust for that minimum margin  
	var div_margin = hud_size.x * slots_margin; 
	var div_x = (hud_size.x - div_margin) /total_slots;
	
	for i in range(total_slots):
#		inventory.append(null);
		var slot = Slot.instance();
		$HUD/InventoryHUD.add_child(slot)
		slot.name = "InventorySlot%d" % i
		slot.index = i

		slot.position = Vector2(0.5 * div_margin + i* div_x + 0.5*div_x, hud_size.y/2 )
		slots.append(slot);

#func create_queue():

#	var queue_hud_size = $HUD/QueueHUD.get_rect().size
#	for i in range(queue_slots):
#		queue.append(null);
#		modulate.a8 = 155;
#

func _on_Item_pickup(item):
	var is_full = true;
	for i in range(total_slots):
		if !slots[i].item:
			slots[i].insert_item(item)
			item.item_to_inventory(i)
			is_full = false
			break
	if is_full:
		print("Inventory full taking damage")
		item.queue_free()
#	inventory.append(item) 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Input.is_action_just_pressed("restart")):
		get_tree().reload_current_scene()
	pass

func _on_ItemTimer_timeout():
	var item = Item.instance();
	add_child(item);
	var item_range = rand_range(0, screen_size.x);
	item.position = Vector2(item_range, $ItemPosition.position.y);
	
	var dict_keys = global.asset_dict[global.current_act].keys()
	var rand_index = round(rand_range(0, dict_keys.size() - 1))
	print(rand_index)
	var current_item_name = dict_keys[rand_index]
	var current_item_data = global.asset_dict[global.current_act][current_item_name]
	item._loadJSON(current_item_data);



func _on_QueueTimer_timeout():
	var QueueItem = QueueSlot.instance()
	add_child(QueueItem)
	pass # Replace with function body.
