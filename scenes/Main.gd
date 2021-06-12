extends Node2D
export (PackedScene) var Item;
const Slot = preload("res://scenes/InventorySlot.tscn")
#Stays constant thanks to settings
var screen_size;
export var queue_slots = 6;
export var total_slots = 1;
export var min_slot_offset = 0.4;

var inventory = []
var queue = []
var slots = []

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size;
	$ItemTimer.start();
	$Player.connect("item_collected", self, "_on_Item_pickup")
	# slots.append($HUD/InventoryHUD/InventorySlot1)
	print(slots)
	create_inventory()
	pass # Replace with function body.

func create_inventory():
	var hud_size = $HUD/InventoryHUD.get_rect().size
	# if div_x - slot_size - margin/2 is negative, adjust the scale of slot to adjust for that minimum margin  
	var div_x = hud_size.x /total_slots;
	
	for i in range(total_slots):
		inventory.append(null);
		var slot = Slot.instance();
		$HUD/InventoryHUD.add_child(slot)
		slot.name = "InventorySlot%d" % i
		# var new_pos = Vector2(0, hud_size.y/2)
		# var slot_sprite = slot.get_child(0);
		# var div_margin = (div_x - slot_sprite.get_rect().size.x) /2;
		# if (total_slots % 2 == 0):
		# 	new_pos.x = hud_size.x/2;
		# 	pass
		# else:
		# 	new_pos.x = hud_size.x/2;
		slot.position = Vector2(i* div_x + 0.5*div_x,hud_size.y/2 )
		slots.append(slot);

# func create_queue():
# 	var queue_hud_size = $HUD/QueueHUD.get_rect().size
# 	for i in range(queue_slots):
# 		queue.append(null);
# 		modulate.a8 = 155;
		

func _on_Item_pickup(item):
	var is_full = true;
	for i in range(total_slots):
		if !inventory[i]:
			inventory[i] = item
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

