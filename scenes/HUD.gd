extends CanvasLayer
onready var global = $"/root/Global"
var life = preload("res://assets/life.png")
var life_empty = preload("res://assets/life_empty.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	$ActLabel.text = global.current_act
	$ActLabel.hide();

func show():
	$PointLabel.show();
	$ActLabel.show()
	$LifeBar.show();
	$InventoryHUD.show()
	$QueueHUD.show();


func hide():
	$PointLabel.hide();
	$ActLabel.hide()
	$LifeBar.hide();
	$InventoryHUD.hide()
	$QueueHUD.hide();

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
