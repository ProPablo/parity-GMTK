extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
enum ACT_4 {
	NONE
	GRAVITY_CHARGING,
	GRAVITY_FIRING,
}
var act_state = 0
const Main = preload("res://scenes/Main.gd")
onready var global = $"/root/Global"
onready var main = $"/root/Main"

# Called when the node enters the scene tree for the first time.
func _ready():
	match global.current_act:
		"Act_5":
			main.INIT_VEL_HIGH = 100
			main.INIT_VEL_LOW = 20
		"Act_8":
			yield(main, "ready")
			print("Dinosaurs: 0_0")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func ACT_4():
	match(act_state):
		ACT_4.NONE:
			pass
		ACT_4.GRAVITY_FIRING:
			pass

