extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#tick_tack_sound
onready var sound = get_node("tick_tack_sound")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Start_pressed():
	if not SceneChanger.is_changing_scene():
		sound.play()
		SceneChanger.goto_scene("res://scenes/alarm.tscn", 2)
#
#func _on_Start_pressed():
#	print('_on_Start_pressed')
#	var fader = get_node("fader")
#	if not fader.is_fading():
#		sound.play()
#		fader.fade(2)
#		print("start_game")
#
#func faded():
#	print('faded')
#	GameStatus.start_new_game()
#	SceneChanger.goto_scene("res://scenes/alarm.tscn")
