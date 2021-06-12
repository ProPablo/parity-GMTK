extends Camera2D

export var decay = 0.5
export var max_offset = Vector2(100, 75)
export var max_roll = 0.05
var trauma = 0.0
var trauma_power = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()

func add_trauma(amount):
	trauma = min(trauma + amount, 1.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()
	
func shake():
	var amount = pow(trauma, trauma_power)
	rotation = max_roll * amount * rand_range(-1, 1)
	offset.x  = max_offset.x * amount * rand_range(-1, 1)
	offset.y  = max_offset.x * amount * rand_range(-1, 1)
	

