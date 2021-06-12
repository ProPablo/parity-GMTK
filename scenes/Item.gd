extends KinematicBody2D

export var GRAVITY = 98;

var velocity = Vector2()
var mass = 1;
var points = 1;

# Called when the node enters the scene tree for the first time.
func _ready():
	var dict = $"/root/Global".asset_dict
	var current_data = dict["Act1"]["Flappy_bird"]
	
	print(current_data["text"])
	$ObjectSprite.texture = load(current_data["text"])
	if current_data.has("region"):
		$ObjectSprite.region_enabled = true
		var reg = current_data["region"]
		$ObjectSprite.region_rect = Rect2(reg[0], reg[1], reg[2], reg[3])
	if current_data.has("hf"):
		$ObjectSprite.hframes = current_data["hf"]
	if current_data.has("vf"):
		$ObjectSprite.vframes = current_data["vf"]
	if current_data.has("mass"):
		mass = current_data["mass"]
	if current_data.has("points"):
		points = current_data["points"]
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	velocity += Vector2(0,1) * GRAVITY * delta;
	move_and_slide(velocity);
