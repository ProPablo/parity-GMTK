extends Node2D

onready var global = $"/root/Global"

enum {
	IDLE,
	CRAFTING,
	EXPIRING,
	TRAVEL_BACK
}

var state = IDLE

var item = null;
var index = null;

var t = 0.0
var move_to

var slot_size;
var queue_to_craft = null;

export var shake_scalar = 5.0
export var expire_time = 2.5

var time_to_craft
var move_back_time = 0.1

var original_position = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	slot_size = $SlotSprite.get_rect().size * $SlotSprite.scale
	randomize()
	$SlotAnimation.playback_speed = 1/expire_time;
	time_to_craft = $"/root/Main".time_to_craft

func insert_item(new_item):
	original_position = position
	item = new_item
	_start_expiring()

func _return():
	print("travelling back")
	item.queue_free()
	item =null
	state = TRAVEL_BACK
	t = 0.0
	$SlotSprite.modulate = Color(1.0, 1.0, 1.0, 1.0)
	queue_to_craft = null

func _start_expiring():
	state = EXPIRING
	$SlotAnimation.play("Expiring");

func _start_crafting(queue):
	$SlotAnimation.play("Idle")
	$SlotSprite.modulate = queue.color
	queue_to_craft = queue
	state = CRAFTING;
	move_to = Vector2(global.screen_size.x /2, position.y + -2 * slot_size.y)
	t = 0.0


func _on_slot_expire():
	
#	print("Fukin done")
	# reset position so it's not maligned
	$SlotSprite.position.x = item.position.x
	$SlotSprite.position.y = item.position.y
	item.queue_free()
	item = null
	$SlotSprite.self_modulate = Color(1.0, 1.0, 1.0, 1.0)
	state = IDLE
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match state:
		EXPIRING:
			$SlotSprite.position.x = $SlotAnimation.current_animation_position  * shake_scalar * randf()
			$SlotSprite.position.y = $SlotAnimation.current_animation_position  * shake_scalar * randf()
		CRAFTING:
			t+= delta
			if (t >= time_to_craft):
				position = move_to
				state = IDLE
#			position.move_toward(move_to, delta * 220000)
			position = position.linear_interpolate(move_to, t / time_to_craft)
		IDLE:
			pass
		TRAVEL_BACK:
			t+= delta
			if (t >= move_back_time):
				t = 0.0
				state = IDLE
				position = original_position
				
#			position.move_toward(move_to, delta * 220000)
			position = position.linear_interpolate(original_position, t / move_back_time)


