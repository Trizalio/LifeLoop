extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var money: float = 50
var health: float = 50
var family: float = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func got_to_office():
	
	yield(get_tree().create_timer(5), "timeout")
	SceneChanger.goto_scene("res://scenes/city.tscn")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
