extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var item = null;
var index = null;

export var shake_scalar = 5.0
export var expire_time = 2.5

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$SlotAnimation.playback_speed = 1/expire_time;
	pass # Replace with function body.

func insert_item(new_item):
	item = new_item
	$SlotAnimation.play("Expiring");


func _on_slot_expire():
	print("Fukin done")
	# reset position so it's not maligned
	$SlotSprite.position.x = item.position.x
	$SlotSprite.position.y = item.position.y
	item.queue_free()
	item = null
	$SlotSprite.self_modulate = Color(1.0, 1.0, 1.0, 1.0)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !item:
		return
	$SlotSprite.position.x = $SlotAnimation.current_animation_position  * shake_scalar * randf()
	$SlotSprite.position.y = $SlotAnimation.current_animation_position  * shake_scalar * randf()
	pass
