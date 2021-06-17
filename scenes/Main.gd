extends Node2D
export (PackedScene) var Item;
const Slot = preload("res://scenes/Slot.tscn")
const SlotClass = preload("res://scenes/Slot.gd")
const QueueSlot = preload("res://scenes/QueueSlot.tscn")
const Present = preload("res://scenes/Present.tscn")
onready var global = $"/root/Global"

export var queue_slots = 6;
export var total_slots = 5;
export var slots_margin = 0.3;


var points = 0;
var game_over = false;
var life_count = 3;
var crafting_slots = [];
var currently_crafting;
var queues = []
var slots = []

var present = null

var time_to_craft = 3.0

# inevntory items stored in queue
# var inventory = []

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$HUD.hide()
	$GOMenu.hide()
	$ItemTimer.start()
	$QueueTimer.start()
	$HUD/PointLabel.text = "Points: " + str(points)
	$Player.connect("item_collected", self, "_on_Item_pickup")
	$HUD.connect("game_over", self, "_on_gameover")
	_on_gamestart()
	$PlanetSprite.texture = load("res://assets/" + str(global.current_act).to_lower() + "planet.png")
	get_node("/root/Music/Music").play();
	create_inventory()
	$CraftingTimer.wait_time = time_to_craft


func create_inventory():
	var hud_size = $HUD/InventoryHUD.get_rect().size
	# if div_x - slot_size - margin/2 is negative, adjust the scale of slot to adjust for that minimum margin  
	var div_margin = hud_size.x * slots_margin; 
	var div_x = (hud_size.x - div_margin) /total_slots
	
	for i in range(total_slots):
#		inventory.append(null);
		var slot = Slot.instance();
		$HUD/InventoryHUD.add_child(slot)
		slot.name = "InventorySlot%d" % i
		slot.index = i

		slot.position = Vector2(0.5 * div_margin + i* div_x + 0.5*div_x, hud_size.y/2 )
		slot.connect("area_entered", self, "_stop_crafting")
		slots.append(slot);

func _on_Item_pickup(item):
	if (game_over):
		return;
	$ShakeCamera2D.add_trauma(0.1);
	var is_full = true;
	get_node("/root/Music/ItemPickup").play();
	for i in range(total_slots):
		if !slots[i].item:
			slots[i].insert_item(item)
			item.item_to_inventory(i)
			is_full = false
			break
	if is_full:
		item.queue_free()
		life_down()

func _on_gameover():
	game_over = true
	$HUD/InventoryHUD.hide();
	$HUD/QueueHUD.hide();
	$ItemTimer.stop();
	$QueueTimer.stop();
	get_node("/root/Music/Music").stop();
	get_node("/root/Music/GameOver").play();
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_gamestart():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	get_tree().call_group("items", "queue_free");
	$HUD.show();
	$GOMenu.hide();
	$HUD/ActLabel.text = global.current_act.to_upper();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if currently_crafting == null:
		check_crafting()
	
	if (Input.is_action_just_pressed("restart")):
		get_tree().reload_current_scene()
	pass

func check_crafting():
	for q in queues:
		var selected_q = []

		for q_item in q.items:
#		Instead use inventory buffer queue (sorted slots in orer of oldest filled)
			for slot in slots:
				if slot.item == null || slot.state != 2:
					continue
				if (slot.item._name == q_item._name && !selected_q.has(slot.index)):
					selected_q.append(slot.index);
					break
		
		if (selected_q.size() >= q.items.size()):
			crafting_slots = selected_q
			currently_crafting = q
			currently_crafting.enable_crafting()
			for s in crafting_slots:
				slots[s]._start_crafting(q)
			$CraftingTimer.start()
	
func _on_ItemTimer_timeout(): 
	var item = Item.instance();
	add_child(item);
	var item_range = rand_range(0, global.screen_size.x*2);
	item.position = Vector2(item_range, $ItemPosition.position.y);
	var dict_keys = global.asset_dict[global.current_act].keys()
	var rand_index = randi() % dict_keys.size()
#	var rand_index = randi() % 2
#	print(rand_index)
	var current_item_name = dict_keys[rand_index]
	var current_item_data = global.asset_dict[global.current_act][current_item_name]
	item._loadJSON(current_item_data, current_item_name, Vector2(rand_range(0, .5), rand_range(50, 300)));

func _on_QueueTimer_timeout():
	var size_of_list = queues.size()
	var queue_instance = QueueSlot.instance()
	$HUD/QueueHUD.add_child(queue_instance)
	queue_instance.adjust_index(size_of_list)
	adjust_queues()
	queue_instance.connect("queue_expire", self, "queue_remove")
	queues.append(queue_instance)
	pass # Replace with function body.

func adjust_queues():
	for i in range(queues.size()):
		queues[i].adjust_index(i)

# add tween schmovement
func queue_remove(index):
#	var delete_q = queues.pop_front();
	var delete_q = queues[index]
	queues.erase(delete_q)
	delete_q.call_deferred("free")
	adjust_queues()
	life_down()

func life_down():
	$ShakeCamera2D.add_trauma(0.4)
	life_count -= 1;
	$HUD.display_heart()
	get_node("/root/Music/LifeDown").play();
	if (life_count <= 0): 
		_on_gameover();
		$GOMenu.show()


func _on_CraftingTimer_timeout():
	# just accept sparkly
	points += 1;
	$HUD/PointLabel.text = "Points: " + str(points)
	if (points >= 1):
		global.next_act()
	if (points >= 2 ):
		_on_gameover();
	
#	var present = Present.instance()
#	add_child(present)
#	var collide_position = slots[crafting_slots[0]].global_position 
##
#	present.position = collide_position
#	present.travel(currently_crafting);
	
	for s in crafting_slots:
		slots[s]._return()
	
	crafting_slots = []
	queues.erase(currently_crafting);
	adjust_queues()
	currently_crafting.queue_free()
	currently_crafting = null
	
	
#	when item success crafted -> next act
#	if (points == 10):
#		next_act()
