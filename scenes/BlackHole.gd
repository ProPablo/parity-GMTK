extends Node2D

var player;
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var MASS = 200

#var G = 6.6743e-1
export var G = 12
# Called when the node enters the scene tree for the first time.
func _ready():
	player = $"/root/Main/Player"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var vec_towards = (position - player.position).normalized()
	var distance_squared = position.distance_squared_to(player.position);
	var accel = ((G*MASS) / distance_squared);
	print(accel)
	player.velocity += vec_towards * accel * delta;
	pass


func _input(event):
#	print(event.position)
	if (event is InputEventMouseMotion):
		var mouse_pos = get_global_mouse_position();
		position = mouse_pos;
