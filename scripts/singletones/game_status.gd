extends Node


#var WorkTimeLabel = preload("res://scenes/work_time.tscn")

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
	

var seconds_in_office = 30
var time_steps = 9
var day_start_time = 9
var current_time_step = 0
var got_to_office_from_work = false

func set_office_time(target: Label):
	print('current_time_step: ', current_time_step)
	print('day_start_time: ', day_start_time)
	print('time: ', "%0*d:00" % [2, day_start_time + current_time_step])
	target.text = "%0*d:00" % [2, day_start_time + current_time_step]
	
func return_to_office():
	got_to_office_from_work = true
	SceneChanger.goto_scene("res://scenes/office.tscn")

func got_to_office():
	if got_to_office_from_work:
		got_to_office_from_work = false
		return
	current_time_step = 0
	
	var seconds_per_time_step = seconds_in_office / time_steps
	while current_time_step < time_steps:
		var time_label: Label = get_node('/root/office/time')
		if time_label == null:
			time_label = get_node('/root/work/time')
		set_office_time(time_label)
		yield(get_tree().create_timer(seconds_per_time_step), "timeout")
		current_time_step += 1
	gone_from_office()

func go_to_office():
	SceneChanger.goto_scene("res://scenes/city.tscn")
	yield(SceneChanger, "scene_changed")
	var city = get_node("/root/city")
	var animation = city.get_node("animation")
	animation.play("player_to_work")
	yield(city, "came_to_office")
	SceneChanger.goto_scene("res://scenes/office.tscn")
	
func gone_from_office():
	SceneChanger.goto_scene("res://scenes/city.tscn")
	
