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
			GameStatus.used_home_item(selected_object.name)
			var sound = selected_object.get_node('sound')
			if sound is AudioStreamPlayer2D:
				sound.play()
		
func _ready():
	selected_object_index = 0
	limit_selectable_objects_to()

func select_object(new_object_index: int):
	print('select_object', new_object_index)
	new_object_index = new_object_index % len(scene_objects)
	selected_object = scene_objects[selected_object_index]
	if selected_object != null:
		selected_object.use_parent_material = false
		
	selected_object = scene_objects[new_object_index]
	selected_object.use_parent_material = true
	selected_object_index = new_object_index

func limit_selectable_objects_to(object_names = null):
	print('limit_selectable_objects_to: ', object_names)
	var new_scene_objects = []
	var items = $items.get_children()
	for i in len(items):
		var object = items[i]
		if object_names == null or object.name in object_names:
			new_scene_objects.append(object)
	scene_objects = new_scene_objects
	select_object(int(len(scene_objects) / 2))
