extends Node



var no_effect: float = 0
var small_effect: float = 5
var medium_effect: float = 10
var strong_effect: float = 15

var money_per_sheet: float = 1
var stress_per_mistake: float = 1

var buildings = [
	ResoureChange.new('park', no_effect, no_effect, no_effect),
	ResoureChange.new('grocery_store', -small_effect, no_effect, small_effect),
	ResoureChange.new('gym', -small_effect, small_effect, no_effect),
	ResoureChange.new('bar', -medium_effect, medium_effect, -small_effect),
	ResoureChange.new('clothing_store', -medium_effect, no_effect, medium_effect),
	ResoureChange.new('stripclub', -strong_effect, strong_effect, -medium_effect),
	ResoureChange.new('jewelry_store', -strong_effect, no_effect, strong_effect),
]
var name_to_building = {}


var items = [
	ResoureChange.new('bottle', -small_effect, small_effect, no_effect),
]
var name_to_items = {}
var day_to_buildings = {}


class ResoureChange:
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

#var ResourseBars = preload("res://scenes/bars.tscn")
signal resources_changed
var money: float = 50
var stress: float = 50
var family: float = 50

var resourse_bars = null

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in len(buildings):
		var building: ResoureChange = buildings[i]
		name_to_building[building.title] = building
	for i in len(items):
		var item: ResoureChange = items[i]
		name_to_items[item.title] = item
	
	var day_to_buildings = {
		1: [name_to_building.bar, name_to_building.grocery_store],
		2: [name_to_building.bar],
	#	1: ['bar'],
	#	2: ['grocery_store', 'park'],
	#	3: ['grocery_store', 'park', 'gym'],
	#	4: ['grocery_store', 'park', 'gym', 'bar', 'clothing_store'],
	#	5: ['grocery_store', 'park', 'gym', 'bar', 'clothing_store', 'jewelry_store', 'strip_club'],
	}
	
func start_new_game():
	money = 50
	stress = 50
	family = 50
	current_day = 0
#	var resourse_bars = ResourseBars.instance()
#	get_node("/root").add_child(resourse_bars)
	
func end_game():
#	get_node("/root").remove_child(resourse_bars)
	pass
	
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

var current_day = 0

func set_office_time(target: Label):
	target.text = "%0*d:00" % [2, day_start_time + current_time_step]
	
func return_to_office():
	got_to_office_from_work = true
	SceneChanger.goto_scene("res://scenes/office.tscn")

func got_to_office():
	get_node('/root/office').limit_selectable_objects_to([
		'lamp', 'printer', 'whiteboard', 'ball'
	])
	if got_to_office_from_work:
		got_to_office_from_work = false
		return
	current_day += 1
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
	city.come_to_office(['work'])
	yield(city, "came_to_office")
	SceneChanger.goto_scene("res://scenes/office.tscn")

func on_building_used(building_name: String):
	print('building_used: ', building_name)
	if building_name == 'home':
		came_home()
		return
	var building_data: ResoureChange = name_to_building[building_name]
	
	modify_resourses(building_data.money_effect, building_data.stress_effect, 
												building_data.family_effect)
												
func used_item(item_name):
	if item_name == 'bed':
		go_to_office()
		return
	var item_data: ResoureChange = name_to_items[item_name]
	modify_resourses(item_data.money_effect, item_data.stress_effect, 
												item_data.family_effect)

func modify_resourses(money_value: float, stress_value: float, family_value: float):
	print('modify_resourses', money_value, stress_value, family_value)
	money += money_value
	stress += stress_value
	family += family_value
	if money < 0:
		game_over('no_money')
	if stress < 0:
		game_over('died')
	if family < 0:
		game_over('lost_family')
	emit_signal("resources_changed")

func game_over(ending_name: String):
	pass

func came_home():
	SceneChanger.goto_scene("res://scenes/home.tscn")
	yield(SceneChanger, "scene_changed")
	var home = get_node("/root/home")
	home.limit_selectable_objects_to(['bed', 'bottle'])

func work_done(result_is_correct):
	if result_is_correct:
		modify_resourses(money_per_sheet, 0, 0)
	else:
		modify_resourses(0, stress_per_mistake, 0)

func gone_from_office():
	SceneChanger.goto_scene("res://scenes/city.tscn")
	yield(SceneChanger, "scene_changed")
	var city = get_node("/root/city")
	city.connect("building_used", self, "on_building_used")
	print('city.connect("building_used", self, "on_building_used")')
	city.start_at_office(day_to_buildings[current_day])
	
