extends CanvasLayer
signal start_game;

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func show():
	$TitleLabel.show();
	$StartButton.show()
	$StartButton/StartSprite.show();

func hide():
	$TitleLabel.hide();
	$StartButton.hide()
	$StartButton/StartSprite.hide();

func _on_StartButton_pressed():
	get_tree().change_scene("res://scenes/Main.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
