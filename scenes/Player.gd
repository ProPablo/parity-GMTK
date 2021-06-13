extends Node2D

signal item_collected(item)

export var MASS = 200

onready var p_div = $PlayerContainer;
var angular_velocity = 0
export var GRAVITY = 98


#var G = 6.6743e-1
export var G = 12
var influenced = []
# Called when the node enters the scene tree for the first time.
func _ready():
	
	p_div.rotation = 3* PI/4;
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for body in influenced:
		var vec_towards = (position - body.position).normalized()
		var distance_squared = position.distance_squared_to(body.position);
		var accel = ((G*MASS) / distance_squared);
#	print(accel)
		body.velocity += vec_towards * accel * delta;
	
#	rotation = pi/2 to -pi/2

func _input(event):
	if (event is InputEventMouseMotion):
		var mouse_pos = get_global_mouse_position();
		position = mouse_pos;
		# print(Input.get_last_mouse_speed())
			
	#	# removing negative with one value
	#	var normalized_jump = velocity.y + jump_velocity;
	#	# ensuring that normalized_jump is value you want between -ve to +ve (A,B)
	#	var t = (clamp(normalized_jump, 0, 2 * jump_velocity)) / (2 * jump_velocity);
	#	$FlappyBird.rotation = deg2rad(-60) * (1 - t) + deg2rad(60) * t;
		
#		if (event.relative.x > 0):
#			$DanglingAnimation.assigned_animation = "Dangling_right"
#		if (event.relative.x < 0):
#			$DanglingAnimation.assigned_animation = "Dangling_left"

func _physics_process(delta):
#	var rot = p_div.rotation;
##	var directional_vec = Vector2(cos(rot), sin(rot))
##	print(directional_vec)
#	var r = 64;
#	angular_velocity += (GRAVITY * delta *sin(rot))  / r
#	p_div.rotation += angular_velocity * delta;
	pass

func _on_Influence_body_entered(body):
	if body.is_slotted:
		return
	print(body.name + "has entered the cum zone")
	influenced.append(body)
	pass # Replace with function body.


func _on_Influence_body_exited(body):
	if body.is_slotted:
		return
	print(body.name + "has left the cum zone")
	influenced.erase(body)
	pass # Replace with function body.


func _on_Pickup_body_entered(body):
	if body.is_slotted:
		return
	print(body.name + "has coomed")
	influenced.erase(body)
	emit_signal("item_collected", body)
	pass # Replace with function body.
