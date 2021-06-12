extends Node2D

var player;
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var MASS = 200

#var G = 6.6743e-1
export var G = 12
var influenced = []
# Called when the node enters the scene tree for the first time.
func _ready():
	player = $"/root/Main/Object"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for body in influenced:
		var vec_towards = (position - body.position).normalized()
		var distance_squared = position.distance_squared_to(body.position);
		var accel = ((G*MASS) / distance_squared);
#	print(accel)
		body.velocity += vec_towards * accel * delta;
		


func _input(event):
#	print(event.position)
	if (event is InputEventMouseMotion):
		var mouse_pos = get_global_mouse_position();
		position = mouse_pos;


func _on_Influence_body_entered(body):
	print(body.name + "has entered the cum zone")
	influenced.append(body)
	pass # Replace with function body.


func _on_Influence_body_exited(body):
	print(body.name + "has left the cum zone")
	influenced.erase(body)
	pass # Replace with function body.


func _on_Pickup_body_entered(body):
	pass # Replace with function body.
