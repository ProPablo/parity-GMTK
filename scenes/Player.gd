extends Node2D

signal item_collected(item)
export var MASS = 200
var game_over

onready var p_div = $PlayerContainer;
var angular_velocity = 0
export var DANGLE_GRAVITY = 98
export var DAMPENING = 2
export var STARTING_ANGLE = -PI/2
export var MOUSE_SPEED = 0.01
export var BODY_LENGTH = 64


#var G = 6.6743e-1
export var G = 12
var influenced = []
# Called when the node enters the scene tree for the first time.
func _ready():
	
	p_div.rotation = 3* PI/4;
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	pass # Replace with function body.


func _input(event):
	if (event is InputEventMouseMotion && !get_tree().get_current_scene().game_over ):
		var mouse_pos = get_global_mouse_position();
		position = Vector2(clamp(mouse_pos.x, 1, 566), mouse_pos.y);
		
		var rot = p_div.rotation + PI/2;
		var mouse_vel_x = Input.get_last_mouse_speed().x
		var mouse_vel_y = Input.get_last_mouse_speed().y
		angular_velocity += (mouse_vel_x * MOUSE_SPEED *cos(rot))  / BODY_LENGTH
		angular_velocity += (mouse_vel_y * MOUSE_SPEED *sin(rot))  / BODY_LENGTH


func _physics_process(delta):
	for body in influenced:
		var vec_towards = (position - body.position).normalized()
		var distance_squared = position.distance_squared_to(body.position);
		var accel = ((G*MASS) / distance_squared);
		body.velocity += vec_towards * accel * delta;

	var rot = p_div.rotation + PI/2;
	var directional_vec = Vector2(cos(rot), sin(rot))

	angular_velocity += (DANGLE_GRAVITY * delta *sin(rot))  / BODY_LENGTH
	angular_velocity += -sign(angular_velocity) * DAMPENING * delta
	p_div.rotation += angular_velocity * delta


func _on_Influence_body_entered(body):
	if body.is_slotted:
		return
	influenced.append(body)
	pass # Replace with function body.


func _on_Influence_body_exited(body):
	if body.is_slotted:
		return
	influenced.erase(body)
	pass # Replace with function body.


func _on_Pickup_body_entered(body):
	if body.is_slotted:
		return
#	print(body.name + "has coomed")
	influenced.erase(body)
	emit_signal("item_collected", body)
	pass # Replace with function body.
