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
		if selected_object != null:
			GameStatus.used_item(selected_object.name)
		
func _ready():
	selected_object_index = 0
	scene_objects = $items.get_children()
	select_object(0)

func select_object(new_object_index: int):
	print('select_object', new_object_index)
	new_object_index = new_object_index % len(scene_objects)
	selected_object = scene_objects[selected_object_index]
	if selected_object != null:
		selected_object.use_parent_material = false
		
	selected_object = scene_objects[new_object_index]
	selected_object.use_parent_material = true
	selected_object_index = new_object_index

func limit_selectable_objects_to(object_names):
	print('limit_selectable_objects_to: ', object_names)
	var new_scene_objects = []
	for i in len(scene_objects):
		var object = scene_objects[i]
		if object.name in object_names:
			new_scene_objects.append(object)
	scene_objects = new_scene_objects
	select_object(0)
