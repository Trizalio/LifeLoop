extends Node


var no_effect: float = 0
var small_effect: float = 5
var medium_effect: float = 10
var strong_effect: float = 15

var buildings = [
	BuildingData.new('grocery_store', -small_effect, small_effect, no_effect),
	BuildingData.new('bar', -medium_effect, -small_effect, medium_effect),
]
var name_to_building = {}

#const day_to_buildings = {
#	1: ['bar'],
#	2: ['grocery_store', 'park'],
#	3: ['grocery_store', 'park', 'gym'],
#	4: ['grocery_store', 'park', 'gym', 'bar', 'clothing_store'],
#	5: ['grocery_store', 'park', 'gym', 'bar', 'clothing_store', 'jewelry_store', 'strip_club'],
#}

class BuildingData:
	var title: String = ''
	var money_effect: float = 0
	var stress_effect: float = 0
	var family_effect: float = 0
	
	func _init(_title: String, _money_effect: float, _stress_effect: float, _family_effect: float):
#		print('_init: ', new_nickname, " ", new_id, " ", new_achievements)
		title = _title
		money_effect = _money_effect
		stress_effect = _stress_effect
		family_effect = _family_effect

#var WorkTimeLabel = preload("res://scenes/work_time.tscn")

var money: float = 50
var health: float = 50
var family: float = 50


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in len(buildings):
		var building: BuildingData = buildings[i]
		name_to_building[building.title] = building
	
func start_new_game():
	money = 50
	health = 50
	family = 50
	current_day = 0
	
func try_find(location: String):
	var node = get_node(location)
	print(location, ": ", node)
	if node != null:
		node.print_tree()
	

var seconds_in_office = 3
var time_steps = 9
var day_start_time = 9
var current_time_step = 0
var got_to_office_from_work = false

var current_day = 0

func set_office_time(target: Label):
	target.text = "%0*d:00" % [2, day_start_time + current_time_step]
	
func return_to_office():
	got_to_office_from_work = true
	SceneChanger.goto_scene("res://scenes/office.tscn")

func got_to_office():
	current_day += 1
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
	city.come_to_office()
	yield(city, "came_to_office")
	SceneChanger.goto_scene("res://scenes/office.tscn")

func on_building_used(building_name: String):
	print('building_used: ', building_name)
	var building_data: BuildingData = name_to_building[building_name]
	print('building_used: ', building_name)
	
func gone_from_office():
	SceneChanger.goto_scene("res://scenes/city.tscn")
	yield(SceneChanger, "scene_changed")
	var city = get_node("/root/city")
	city.connect("building_used", self, "on_building_used")
	print('city.connect("building_used", self, "on_building_used")')
	city.start_at_office(['home',  'bar', 'work'])
	
