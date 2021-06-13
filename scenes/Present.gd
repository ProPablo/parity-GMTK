extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speed = 50

var queue

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func travel(q):
	queue = q

func _physics_process(delta):
	var movement = position.move_toward(queue.position, delta * speed);
	move_and_collide(movement)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
