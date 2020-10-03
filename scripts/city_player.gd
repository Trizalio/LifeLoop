extends Node2D

func _input(event):
	var user_selection_input = InputController.get_selection_from_event(event)
	if user_selection_input == InputController.UserSelectionInput.use:
		if active_building == bar:
			pass
			

var active_building: Node2D = null
var buildings = []
var bar = null
var work = null
var home = null


func _ready():
	bar = get_node('../buildings/bar')
	work = get_node('../buildings/work')
	home = get_node('../buildings/home')
	bar.material.set_shader_param("power", 2.0)
	buildings = [bar, work, home]
#	buildings = [home]
	motion = Vector2()
	
var motion = Vector2()
const SPEED = 250

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move(delta)
#	check_buildings_nearly()
	
func check_buildings_nearly():
	for i in len(buildings):
		var building: Node2D = buildings[i]
		var delta_position = position - building.position
		var glow_power = clamp(40 / delta_position.length(), 0.2, 5.0)
		if glow_power > 1:
			glow_power = 3.0
			active_building = building
		building.material.set_shader_param("power", glow_power)
#		print('building.material.set_shader_param("power", ', glow_power, ')')
	
func move(delta):
	var user_move_input = InputController.get_direction()
	
	var player_sprite: AnimatedSprite = get_node("Sprite")
	motion = Vector2()
	if user_move_input == InputController.UserMoveInput.up:
		motion += Vector2(0, -1)
		player_sprite.animation = 'up'
	elif user_move_input == InputController.UserMoveInput.down:
		motion += Vector2(0, 1)
		player_sprite.animation = 'down'
	elif user_move_input == InputController.UserMoveInput.left:
		motion += Vector2(-1, 0)
		player_sprite.animation = 'side'
		if player_sprite.scale.x > 0:
			player_sprite.scale.x *= -1
	elif user_move_input == InputController.UserMoveInput.right:
		motion += Vector2(1, 0)
		player_sprite.animation = 'side'
		if player_sprite.scale.x < 0:
			player_sprite.scale.x *= -1
	else:
		motion = Vector2(0, 0)
#
	if motion != Vector2(0, 0):
		position += motion * delta * SPEED
		check_buildings_nearly()

