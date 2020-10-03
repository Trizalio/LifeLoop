extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
enum UserSelectionInput{next, last, use}
enum UserMoveInput{left, right, up, down}
		
func get_selection_from_event(event: InputEvent):
	if event is InputEventKey and event.echo == false and event.pressed == true:
		if event.scancode == KEY_A:
			return UserSelectionInput.last
		elif event.scancode == KEY_D:
			return UserSelectionInput.next
		elif event.scancode == KEY_SPACE:
			return UserSelectionInput.use
		


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
