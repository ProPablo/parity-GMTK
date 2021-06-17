extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	show();

func show():
	$EndLabel.show()
	$StartButton.show()
	$QuitButton.show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func hide():
	$EndLabel.hide();
	$StartButton.hide()
	$QuitButton.hide();

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_QuitButton_pressed():
	get_tree().quit()


func _on_StartButton_pressed():
	get_tree().change_scene("res://scenes/StartMenu.tscn")
