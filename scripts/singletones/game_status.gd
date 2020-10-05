extends Node



var no_effect: float = 0
var small_effect: float = 5
var medium_effect: float = 10
var strong_effect: float = 15

var money_per_sheet: float = 5
var stress_per_sheet: float = -2
var stress_per_mistake: float = -5

var buildings = [
	ResourseChange.new('park', no_effect, no_effect, no_effect),
	ResourseChange.new('grocery_store', -small_effect, no_effect, small_effect),
	ResourseChange.new('gym', -small_effect, small_effect, no_effect),
	ResourseChange.new('bar', -medium_effect, medium_effect, -small_effect),
	ResourseChange.new('clothing_store', -medium_effect, no_effect, medium_effect),
	ResourseChange.new('strip_club', -strong_effect, strong_effect, -medium_effect),
	ResourseChange.new('jewelry_store', -strong_effect, no_effect, strong_effect),
]
var name_to_building = {}


var home_items = [
	ResourseChange.new('bookshelf', no_effect, no_effect, no_effect),
	ResourseChange.new('tv', no_effect, no_effect, no_effect),
	ResourseChange.new('crack', no_effect, no_effect, no_effect),
	ResourseChange.new('bed', no_effect, no_effect, no_effect),
	ResourseChange.new('bottle', -small_effect, small_effect, no_effect),
	ResourseChange.new('sink', no_effect, no_effect, no_effect),
]
var name_to_home_items = {}
var time_steps_to_home_items = {}


var office_items = [
	ResourseChange.new('correct_sheet', money_per_sheet, stress_per_sheet, no_effect),
	ResourseChange.new('mistake_sheet', no_effect, stress_per_mistake, no_effect),
	ResourseChange.new('printer', no_effect, no_effect, no_effect),
	ResourseChange.new('pc', no_effect, no_effect, no_effect),
	ResourseChange.new('lamp', no_effect, no_effect, no_effect),
	ResourseChange.new('whiteboard', no_effect, no_effect, no_effect),
	ResourseChange.new('ball', no_effect, no_effect, no_effect),
]
var name_to_office_item = {}

var time_steps_to_buildings = {}


class ResourseChange:
	var title: String = ''
	var money_effect: float = 0
	var stress_effect: float = 0
	var family_effect: float = 0
	var total_times_used: int = 0
	var day_times_used: int = 0
	
	func _init(_title: String, _money_effect: float, _stress_effect: float, _family_effect: float):
#		print('_init: ', new_nickname, " ", new_id, " ", new_achievements)
		title = _title
		money_effect = _money_effect
		stress_effect = _stress_effect
		family_effect = _family_effect
		total_times_used = 0
		day_times_used = 0
		
	func on_new_day():
		day_times_used = 0

#var ResourseBars = preload("res://scenes/bars.tscn")
signal resources_changed
signal time_step_changed
var money: float = 50
var stress: float = 50
var family: float = 50

var resourse_bars = null

func prepare_changes(clear_total: bool = true):
	for i in len(buildings):
		var building: ResourseChange = buildings[i]
		if clear_total:
			building.total_times_used = 0
		building.day_times_used = 0
		name_to_building[building.title] = building
	for i in len(home_items):
		var item: ResourseChange = home_items[i]
		if clear_total:
			item.total_times_used = 0
		item.day_times_used = 0
		name_to_home_items[item.title] = item
	for i in len(office_items):
		var item: ResourseChange = office_items[i]
		if clear_total:
			item.total_times_used = 0
		item.day_times_used = 0
		name_to_office_item[item.title] = item

func _ready():
	prepare_changes()
	time_steps_to_buildings = {
		18: ['home', 'grocery_store', 'park', 'gym', 'clothing_store', 'jewelry_store'],
		19: ['home', 'grocery_store', 'park', 'gym', 'clothing_store', 'jewelry_store'],
		20: ['home', 'grocery_store', 'park', 'gym', 'clothing_store'],
		21: ['home', 'grocery_store', 'park', 'gym', 'bar'],
		22: ['home', 'park', 'gym', 'bar', 'strip_club'],
		23: ['home', 'park', 'bar', 'strip_club'],
		24: ['home'],
	}
	
	time_steps_to_home_items = {
		18: ['tv', 'crack', 'bed', 'bottle', 'bookshelf', 'sink'],
		19: ['tv', 'crack', 'bed', 'bottle', 'bookshelf', 'sink'],
		20: ['tv', 'crack', 'bed', 'bottle', 'bookshelf', 'sink'],
		21: ['tv', 'crack', 'bed', 'bottle', 'bookshelf', 'sink'],
		22: ['tv', 'crack', 'bed', 'bottle', 'bookshelf', 'sink'],
		23: ['tv', 'crack', 'bed', 'bottle', 'bookshelf', 'sink'],
		24: ['bed'],
	}
	
func start_new_game():
	prepare_changes()
	money = 50
	stress = 50
	family = 50
	current_day = 0
#	var resourse_bars = ResourseBars.instance()
#	get_node("/root").add_child(resourse_bars)
	
func end_game():
#	get_node("/root").remove_child(resourse_bars)
	pass
	pass

#var seconds_in_office = 30
var day_start_time_step = 9
var current_time_step = day_start_time_step 
var final_time_step_in_office = 18
var time_steps_in_office = 9

var got_to_office_from_work = false

var current_day = 0
var location = null

func set_location(location_name: String):
	print('set_location', location_name)
	location = location_name

func increment_time():
	current_time_step += 1
	emit_signal('time_step_changed')
	if location == 'home':
		var home = get_node("/root/home")
		home.limit_selectable_objects_to(get_home_items())
	if location == 'city':
		var objects = []
		if current_time_step in time_steps_to_buildings:
			objects = time_steps_to_buildings[current_time_step]
		var city = get_node("/root/city")
		city.limit_selectable_objects_to(objects)
	if location == 'office':
		if current_time_step < final_time_step_in_office:
			pass
		elif current_time_step == final_time_step_in_office:
			gone_from_office()

func get_home_items():
	var objects = []
	if current_time_step in time_steps_to_home_items:
		objects = time_steps_to_home_items[current_time_step]
	if 'sink' in objects:
		if name_to_home_items['sink'].day_times_used > 0:
			objects.erase('sink')
	print('get_home_items: ', objects)
	if objects:
		return objects

func return_to_office():
	got_to_office_from_work = true
	SceneChanger.goto_scene("res://scenes/office.tscn")

func got_to_office():
	get_node('/root/office').limit_selectable_objects_to([
		'lamp', 'printer', 'whiteboard', 'pc'
	])
#	if got_to_office_from_work:
#		got_to_office_from_work = false
#		return
#	current_day += 1
#	current_time_step = 0
#
#	var seconds_per_time_step = seconds_in_office / time_steps
#	while current_time_step < time_steps:
#		var time_label: Label = get_node('/root/office/time')
#		if time_label == null:
#			time_label = get_node('/root/work/time')
#		set_office_time(time_label)
#		yield(get_tree().create_timer(seconds_per_time_step), "timeout")
#		current_time_step += 1

func start_new_day():
	current_time_step = day_start_time_step
	prepare_changes()
	emit_signal('time_step_changed')
	go_to_office()
	
func go_to_office():
	SceneChanger.goto_scene("res://scenes/city.tscn")
	yield(SceneChanger, "scene_changed")
	var city = get_node("/root/city")
	city.come_to_office(['work'])
	yield(city, "came_to_office")
	SceneChanger.goto_scene("res://scenes/office.tscn")

func on_building_used(building_name: String):
	print('building_used: ', building_name)
	if building_name == 'home':
		came_home()
		return
	var building_data: ResourseChange = name_to_building[building_name]
	modify_resourses(building_data)
	increment_time()
												
func used_home_item(item_name):
	var item_data: ResourseChange = name_to_home_items[item_name]
	if item_name == 'bed':
		item_data.stress_effect = (22 - current_time_step) * 10
		modify_resourses(item_data)
		start_new_day()
		return
	modify_resourses(item_data)
	increment_time()
												
func used_office_item(item_name):
	var item_data: ResourseChange = name_to_office_item[item_name]
	modify_resourses(item_data)
	increment_time()

func modify_resourses(resource_change: ResourseChange):
	print('modify_resourses', resource_change.title, ', ',
			resource_change.money_effect, ', ', resource_change.stress_effect, ', ',
			resource_change.family_effect)
	resource_change.total_times_used += 1
	resource_change.day_times_used += 1
	money += resource_change.money_effect
	stress += resource_change.stress_effect
	family += resource_change.family_effect
	if money < 0:
		game_over('no_money')
	if stress < 0:
		game_over('died')
	if family < 0:
		game_over('lost_family')
	emit_signal("resources_changed")

func game_over(ending_name: String):
	SceneChanger.goto_scene("res://scenes/epilogue.tscn")

func came_home():
	SceneChanger.goto_scene("res://scenes/home.tscn")
	yield(SceneChanger, "scene_changed")
	var home = get_node("/root/home")
	home.limit_selectable_objects_to(get_home_items())

func work_done(result_is_correct):
	if result_is_correct:
		modify_resourses(name_to_office_item['correct_sheet'])
	else:
		modify_resourses(name_to_office_item['mistake_sheet'])
	increment_time()

func gone_from_office():
	SceneChanger.goto_scene("res://scenes/city.tscn")
	yield(SceneChanger, "scene_changed")
	var city = get_node("/root/city")
	city.connect("building_used", self, "on_building_used")
	print('city.connect("building_used", self, "on_building_used")')
	var objects = []
	if current_time_step in time_steps_to_buildings:
		objects = time_steps_to_buildings[current_time_step]
	city.start_at_office(objects)
	
