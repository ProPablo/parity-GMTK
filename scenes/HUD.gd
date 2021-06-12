extends CanvasLayer
signal start_game;
var timer = 1;
const MAX_TIMER = 5;

# Called when the node enters the scene tree for the first time.
func _ready():
	timer = MAX_TIMER
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
#	# cooldown type concept
#	if (timer <= 0): 
#		timer = MAX_TIMER;
#	timer -= delta;
#	var x = str(stepify(timer, 0.01)).split(".");
#	$InventoryHUD/InventoryTimerLabel.text = x[0] + " : " + x[1]
