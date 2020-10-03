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
	sound.play()
	get_node("AnimationPlayer").play('fade')
	print('_on_Start_pressed')
	
func faded():
	print('faded')
	SceneChanger.goto_scene("res://scenes/alarm.tscn")
