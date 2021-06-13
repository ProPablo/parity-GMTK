extends CanvasLayer
signal start_game;

var life = preload("res://assets/life.png")
var life_empty = preload("res://assets/life_empty.png")

# Called when the node enters the scene tree for the first time.
func _ready():
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
	pass;

func display_heart():
	var life_bar = get_node("LifeBar")
	var life_count = get_parent().life_count
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
