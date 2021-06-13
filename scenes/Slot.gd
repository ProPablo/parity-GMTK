extends Node2D

onready var global = $"/root/Global"

enum {
	IDLE,
	CRAFTING,
	EXPIRING
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

# Called when the node enters the scene tree for the first time.
func _ready():
	slot_size = $SlotSprite.get_rect().size * $SlotSprite.scale
	randomize()
	$SlotAnimation.playback_speed = 1/expire_time;

func insert_item(new_item):
	item = new_item
	_start_expiring()

func _start_expiring():
	state = EXPIRING
	$SlotAnimation.play("Expiring");

func _start_crafting(queue):
	$SlotAnimation.play("Idle")
	$SlotSprite.modulate = queue.color
	queue_to_craft = queue
	state = CRAFTING;
	move_to = Vector2(global.screen_size.x /2, position.y + 2 * slot_size.y)
	t = 0.0
	

func _on_slot_expire():
	print("Fukin done")
	# reset position so it's not maligned
	$SlotSprite.position.x = item.position.x
	$SlotSprite.position.y = item.position.y
	item.queue_free()
	item = null
	$SlotSprite.self_modulate = Color(1.0, 1.0, 1.0, 1.0)
	state = IDLE
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !item:
		return
	match state:
		EXPIRING:
			$SlotSprite.position.x = $SlotAnimation.current_animation_position  * shake_scalar * randf()
			$SlotSprite.position.y = $SlotAnimation.current_animation_position  * shake_scalar * randf()
		CRAFTING:
			t+= delta
			position.move_toward(move_to, t)
		IDLE:
			pass


