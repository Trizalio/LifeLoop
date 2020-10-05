extends Node

func _ready():
	pass

func _input(event):
#	print(event)
	var user_selection_input = InputController.get_selection_from_event(event)
	if user_selection_input == InputController.UserSelectionInput.use:
		GameStatus.start_new_game()
		SceneChanger.goto_scene("res://scenes/alarm.tscn")
