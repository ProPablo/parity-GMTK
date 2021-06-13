extends CanvasLayer
signal start_game;
signal game_over;

var life = preload("res://assets/life.png")
var life_empty = preload("res://assets/life_empty.png")

var global_timer = 0;
var QUEUE_MAX_TIME = 2;
var life_count = 3;

# Called when the node enters the scene tree for the first time.
func _ready():
	global_timer = QUEUE_MAX_TIME;
	$RetryButton.hide();
	hide();

func hide():
#	$PointLabel.hide();
#	$InventoryHUD/InventorySprite.hide();
#	$InventoryHUD/InventoryTimerLabel.hide();
#	$InventoryHUD/InventoryTimerSprite.hide();
#	$QueueHUD/QueueSprite.hide();
#	$QueueHUD/QueueTimerLabel.hide();
#	$QueueHUD/QueueTimerSprite.hide();
	$GOLabel.hide();
	$StartButton.hide();
	
func _on_StartButton_pressed():
	emit_signal("start_game");

func _process(delta):
	if (global_timer <= 0 && life_count > 0): 
		global_timer = QUEUE_MAX_TIME;
#		_on_global_timer_timeout()
	global_timer -= delta;

func _on_global_timer_timeout():
	life_count -= 1;
	display_heart()
	$LifeDown.play();
	if (life_count <= 0): 
		emit_signal("game_over")
		$RetryButton.show();
		$GOLabel.show();

func display_heart():
	var life_bar = get_node("LifeBar")
	for i in life_bar.get_child_count():
		life_bar.get_child(i)
		if (life_count > i):
			life_bar.get_child(i).texture = life
		else:
			life_bar.get_child(i).texture = life_empty


func _on_RetryButton_pressed():
	$GOLabel.hide();
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	get_tree().reload_current_scene()
