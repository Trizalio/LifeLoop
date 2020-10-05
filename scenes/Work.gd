extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var scene_objects = []
var selected_object_index = 0 setget select_object
var selected_object: Node2D = null
var sheet: AnimatedSprite = null
var sheet_animation: AnimationPlayer = null
var seal: AnimatedSprite = null
var audio_negative: AudioStreamPlayer2D = null
var audio_positive: AudioStreamPlayer2D = null


func _input(event):
	var user_selection_input = InputController.get_selection_from_event(event)
	
	if user_selection_input == InputController.UserSelectionInput.last:
		select_object(selected_object_index - 1)
	elif user_selection_input == InputController.UserSelectionInput.next:
		select_object(selected_object_index + 1)
	elif user_selection_input == InputController.UserSelectionInput.use:
		use_seal()

# Called when the node enters the scene tree for the first time.
func _ready():
	sheet = get_node("sheets/current_sheet")
	seal = sheet.get_node("seal")
	audio_positive = get_node("audio/positive")
	audio_negative = get_node("audio/negative")
	sheet_animation = get_node("sheets/animation")
	selected_object_index = 0
	scene_objects = $seals.get_children()
#	scene_objects = [
#		get_node("seals/blue"),
#		get_node("seals/red"),
#		get_node("seals/green"),
#		get_node("seals/exit"),
#	]
	select_object(2)
	select_rules()
	get_next_sheet()
#	GameStatus.set_office_time($time)
	
func select_object(new_object_index: int):
	new_object_index = new_object_index % len(scene_objects)
	selected_object = scene_objects[selected_object_index]
	if selected_object != null:
		selected_object.use_parent_material = false
		
	selected_object = scene_objects[new_object_index]
	selected_object.use_parent_material = true
	selected_object_index = new_object_index
	
func use_seal():
	var seal_color_name = selected_object.name
	if seal_color_name == 'exit':
		GameStatus.return_to_office()
		
	if sheet_animation.is_playing():
		return
	if check_seal(seal_color_name):
		GameStatus.work_done(true)
		audio_positive.play()
	else:
		GameStatus.work_done(false)
		audio_negative.play()
	seal.visible = true
	seal.animation = seal_color_name
	get_next_sheet()
	
func check_seal(seal_color: String):
	if seal_color == 'blue' and sheet.frame in [0, 1]:
		return true
	if seal_color == 'green' and sheet.frame in [2, 3, 4]:
		return true
	if seal_color == 'red' and sheet.frame in [5, 6, 7]:
		return true		
	
func get_next_sheet():
	sheet_animation.play("sheet_move")
	
func select_rules():
	pass

func sheet_in_place():
	sheet_animation.stop(false)
	
func set_new_sheet(i: int):
	sheet.frame = i % sheet.frames.get_frame_count("sheets")
	seal.visible = false

func sheet_removed():
	set_new_sheet(randi())
	sheet_animation.play()
	
