extends Node2D
var queue = null;
var queue_index = null;

export var shake_scalar = 5.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func next_queue():
	$QueueSlotAnimation.play("Expiring")
	$QueueSlotAnimation.playback_speed = get_parent().QUEUE_MAX_TIME

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
