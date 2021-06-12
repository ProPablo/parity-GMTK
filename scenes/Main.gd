extends Node2D
export (PackedScene) var Item;
const DISPLAY_HEIGHT = 800;
const DISPLAY_WIDTH = 560;

export var slot_size = 32;
#export var slot_offset = 32;
#export var slot_increment = 96;
#export var slot_height = 100;

export var inventory = []

var slots = []

# Called when the node enters the scene tree for the first time.
func _ready():
	$ItemTimer.start();
	$Player.connect("item_collected", self, "_on_Item_pickup")
	slots.append($HUD/InventoryHUD/InventorySlot1)
	print(slots)
	pass # Replace with function body.

func _on_Item_pickup(item):
	inventory.append(item) 
	item.item_to_inventory(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Input.is_action_just_pressed("restart")):
		get_tree().reload_current_scene()
	pass

func _on_ItemTimer_timeout():
	var item = Item.instance();
	add_child(item);
	var item_range = rand_range(0, DISPLAY_WIDTH);
	item.position = Vector2(item_range, $ItemPosition.position.y);

