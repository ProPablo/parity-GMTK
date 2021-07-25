extends Node2D

class_name Slot

onready var global = $"/root/Global"

export var shake_scalar = 5.0
export var expire_time = 2.5
export var move_back_time = 0.1
var slot_size
var index
var time_to_craft

enum {
	IDLE,
	CRAFTING,
	EXPIRING,
	TRAVEL_BACK
}
var idle_disabled = false
var state = IDLE
var t = 0.0
var move_to
var item = null;
var queue_to_craft = null;

var original_position = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	slot_size = $SlotSprite.get_rect().size * $SlotSprite.scale
	randomize()
	$SlotAnimation.playback_speed = 1/expire_time;
	time_to_craft = $"/root/Main".time_to_craft

func insert_item(new_item):
	item = new_item
	_start_expiring()

func _return():
	item.queue_free()
	item = null
	state = TRAVEL_BACK
	t = 0.0
	$SlotSprite.modulate = Color(1.0, 1.0, 1.0, 1.0)
	queue_to_craft = null

func _start_expiring():
	state = EXPIRING
	$SlotAnimation.play("Expiring");

func _start_crafting(queue):
	state = CRAFTING;
	$SlotAnimation.play("Idle")
	$SlotSprite.modulate = queue.color
	queue_to_craft = queue
	original_position = position
	move_to = Vector2(global.screen_size.x /2, position.y + -2 * slot_size.y)
	$Tween.interpolate_property(self, "position", position, move_to, time_to_craft, Tween.TRANS_LINEAR)
	$Tween.start()


func _on_slot_expire():
	$SlotSprite.position.x = item.position.x
	$SlotSprite.position.y = item.position.y
	if !idle_disabled:
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
			pass
		IDLE:
			pass
		TRAVEL_BACK:
			t+= delta
			if (t >= move_back_time):
				state = IDLE
				position = original_position
			position = move_to.linear_interpolate(original_position, t / move_back_time)
