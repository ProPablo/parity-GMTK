extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speed = 1000
var velocity = Vector2()

var queue = null
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func travel(q):
	queue = q

func fail():
	queue = null


func _physics_process(delta):
#	if queue != null:
#		velocity += ProjectSettings.get_setting("physics/2d/default_gravity_vector") * delta
#		$present.modulate *= Color(1,1,1, 0.1 * delta)
#		move_and_slide(velocity)
#		return;
#	else:
	if queue!=null:
		return
		
		var diff = queue.global_position - global_position
		diff = diff.normalized()
#		var movement = position.move_toward(queue.position, delta * speed);
		move_and_collide(diff*delta*speed)
	
	
