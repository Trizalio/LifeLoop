extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
enum UserSelectionInput{next, last, use}
enum UserMoveInput{left, right, up, down}
		
func get_selection_from_event(event: InputEvent):
	if event is InputEventKey and event.echo == false and event.pressed == true:
		if event.scancode == KEY_A or event.scancode == KEY_LEFT:
			return UserSelectionInput.last
		elif event.scancode == KEY_D or event.scancode == KEY_RIGHT:
			return UserSelectionInput.next
		elif event.scancode == KEY_SPACE:
			return UserSelectionInput.use
		
func get_direction_from_event(event: InputEvent):
	if event is InputEventKey and event.pressed == true:
		if event.scancode == KEY_A or event.scancode == KEY_LEFT:
			return UserMoveInput.left
		elif event.scancode == KEY_D or event.scancode == KEY_RIGHT:
			return UserMoveInput.right
		elif event.scancode == KEY_W or event.scancode == KEY_UP:
			return UserMoveInput.up
		elif event.scancode == KEY_S or event.scancode == KEY_DOWN:
			return UserMoveInput.down
		
func get_direction():

	if Input.is_action_pressed("ui_up"):
		return UserMoveInput.up
	if Input.is_action_pressed("ui_down"):
		return UserMoveInput.down
	if Input.is_action_pressed("ui_left"):
		return UserMoveInput.left
	if Input.is_action_pressed("ui_right"):
		return UserMoveInput.right
		


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
