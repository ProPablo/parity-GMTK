extends CanvasLayer
signal start_game;
signal game_over;
var timer = 1;
const MAX_TIMER = 5;
#var global_timer = get_parent().global_timer
#var QUEUE_MAX_TIME = get_parent().QUEUE_MAX_TIME
#var life_count = get_parent().life_count
var global_timer = 0;
var QUEUE_MAX_TIME = 5;
var life_count = 3;

# Called when the node enters the scene tree for the first time.
func _ready():
	timer = MAX_TIMER
	global_timer = QUEUE_MAX_TIME;
	$LifeLabel.text = str(life_count)
	
#	$RetryButton.hide();
#	$PointLabel.hide();
#	$InventoryHUD/InventorySprite.hide();
#	$InventoryHUD/InventoryTimerLabel.hide();
#	$InventoryHUD/InventoryTimerSprite.hide();
#	$QueueHUD/QueueSprite.hide();
#	$QueueHUD/QueueTimerLabel.hide();
#	$QueueHUD/QueueTimerSprite.hide();
	$StartButton.hide();

func _on_StartButton_pressed():
	emit_signal("start_game");

func _process(delta):
	pass

	if (global_timer <= 0): 
		global_timer = QUEUE_MAX_TIME;
		_on_global_timer_timeout()
	global_timer -= delta;
	
	# cooldown type concept
	if (timer <= 0): 
		timer = MAX_TIMER;
	timer -= delta;
	var x = str("%.2f" % timer)
	var y = x.split(".");
	
	$InventoryHUD/InventoryTimerLabel.text = y[0] + " : " + y[1]

func _on_global_timer_timeout():
	life_count -= 1;
	$LifeLabel.text = str(life_count)
	if (life_count <= 0): 
		print("YOU HAVE FAILED");
		emit_signal("game_over")
