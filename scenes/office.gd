extends Node


var scene_objects = []
var selected_object_index = 0 setget select_object
var selected_object: Node2D = null


func _input(event):
	var user_selection_input = InputController.get_selection_from_event(event)
	
	if user_selection_input == InputController.UserSelectionInput.last:
		select_object(selected_object_index - 1)
	elif user_selection_input == InputController.UserSelectionInput.next:
		select_object(selected_object_index + 1)
	elif user_selection_input == InputController.UserSelectionInput.use:
#		use_seal()
		if selected_object != null:
			if selected_object.name == 'whiteboard_office':
				SceneChanger.goto_scene("res://scenes/work.tscn")
		
func _ready():
	selected_object_index = 0
	scene_objects = $items.get_children()
#	scene_objects = [
#		get_node("items/ball"),
#		get_node("items/whiteboard_office"),
#		get_node("items/pc"),
#		get_node("items/lamp"),
#		get_node("items/printer"),
#	]
	select_object(0)
	GameStatus.got_to_office()
	GameStatus.set_office_time($time)

func limit_selectable_objects_to(object_names):
	print('limit_selectable_objects_to: ', object_names)
	var new_scene_objects = []
	for i in len(scene_objects):
		var object = scene_objects[i]
		if object.name in object_names:
			new_scene_objects.append(object)
	scene_objects = new_scene_objects
	select_object(0)

func select_object(new_object_index: int):
	new_object_index = new_object_index % len(scene_objects)
	selected_object = scene_objects[selected_object_index]
	if selected_object != null:
		selected_object.use_parent_material = false
		
	selected_object = scene_objects[new_object_index]
	selected_object.use_parent_material = true
	selected_object_index = new_object_index
