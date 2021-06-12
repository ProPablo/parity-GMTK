extends Node2D
export (PackedScene) var Item;
const Slot = preload("res://scenes/InventorySlot.tscn")
#Stays constant thanks to settings
var screen_size;
export var total_slots = 1;
export var slot_offset = 0.4;

var inventory = []
var slots = []

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size;
	$ItemTimer.start();
	$Player.connect("item_collected", self, "_on_Item_pickup")
	slots.append($HUD/InventoryHUD/InventorySlot1)
	print(slots)
	create_inventory()
	pass # Replace with function body.

func create_inventory():
	for i in range(total_slots):
		inventory.append(null);
		var slot = Slot.instance();
		slot.name = "InventorySlot%d" % i
		 
		$HUD/InventoryHUD.add_child(slot)

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

