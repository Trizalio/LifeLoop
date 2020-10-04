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
	
func start_new_game():
	money = 50
	health = 50
	family = 50
	
func try_find(location: String):
	var node = get_node(location)
	print(location, ": ", node)
	if node != null:
		node.print_tree()
	
func go_to_work():
	SceneChanger.goto_scene("res://scenes/city.tscn")
	yield(SceneChanger, "scene_changed")
#	try_find('/root')
	try_find('/root/city/map/player')
#	var city = get_node('/root/city')
#	print('city: ', city)
#	print_tree()

var seconds_in_office = 30
var time_steps = 9
var day_start_time = 9
func got_to_office():
	var seconds_per_time_step = seconds_in_office / time_steps
	var current_time_step = 0
	while current_time_step < time_steps:
		var time_label: Label = get_node('/root/office/time')
		if time_label == null:
			time_label = get_node('/root/work/time')
		var hour
		print('current_time_step: ', current_time_step)
		print('day_start_time: ', day_start_time)
		print('time: ', "%0*d:00" % [2, day_start_time + current_time_step])
		time_label.text = "%0*d:00" % [2, day_start_time + current_time_step]
		yield(get_tree().create_timer(seconds_per_time_step), "timeout")
		current_time_step += 1
		
#	yield(get_tree().create_timer(5), "timeout")
	SceneChanger.goto_scene("res://scenes/city.tscn")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
