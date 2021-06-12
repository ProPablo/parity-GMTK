extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var item = null;
var index = null;

export var shake_scalar = 5.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func insert_item(new_item):
	item = new_item
	$SlotAnimation.play("Expiring");

	$SlotAnimation.playback_speed = 2.0;

func _on_slot_expire():
	print("Fukin done")
	item.queue_free()
	item = null
	$SlotSprite.self_modulate = Color(1.0, 1.0, 1.0, 1.0)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !item:
		return
	$SlotSprite.position = $SlotAnimation.current_animation_position  * shake_scalar
	pass
