extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var sound = get_node("sound")

# Called when the node enters the scene tree for the first time.
func _ready():
	sound.play()
	pass # Replace with function body.
	
func _input(event):
#	print(event)
	var user_selection_input = InputController.get_selection_from_event(event)
	if user_selection_input == InputController.UserSelectionInput.use:
		GameStatus.start_new_day()
			


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
