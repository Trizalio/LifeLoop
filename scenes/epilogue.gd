extends Node

func _ready():
	pass
	
func set_reason(resaon_name: String):
	$epilogue_bg.animation = resaon_name

func _input(event):
#	print(event)
	var user_selection_input = InputController.get_selection_from_event(event)
	if user_selection_input == InputController.UserSelectionInput.use:
		GameStatus.start_new_game()
		SceneChanger.goto_scene("res://scenes/alarm.tscn")
