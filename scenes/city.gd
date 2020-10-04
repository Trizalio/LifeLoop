extends Node

signal came_to_office
signal building_used(name)

enum Building{park, clothing_store, gym, bar, grocery_store, jewelry_store, strip_club}


func _input(event):
	var user_selection_input = InputController.get_selection_from_event(event)
	if user_selection_input == InputController.UserSelectionInput.use:
		if selected_marker:
			print('selected_marker: ', selected_marker)
			emit_signal('building_used', [selected_marker.name])

var marker_nodes = []
var player = null
var selected_marker = null

export (Vector2) var home_position = Vector2(594, 517)
export (Vector2) var work_position = Vector2(211, 151)
export (float) var marker_select_range = 100
export (float) var marker_glow_power = 5
export (float) var default_marker_glow_power = 0.5

func come_to_office():
#	var animation = get_node("animation")
#	animation.play("player_to_work")
	print('come_to_office')
	var player = get_node("map/player")
	player.blink_to_destination(home_position)
	player.move_to_destination(Vector2(594, 152))
	yield(player, 'destination_reached')
	player.move_to_destination(work_position)
	yield(player, 'destination_reached')
	emit_signal("came_to_office")

func start_at_office(buildings_to_act):
	for i in len(marker_nodes):
		var node: Node2D = marker_nodes[i]
		if not(node.name in buildings_to_act):
			node.visible = false


func select_nearest_building():
	var nearest_marker = null
	var nearest_distance = null
	for i in len(marker_nodes):
		var marker: Node2D = marker_nodes[i]
		if not marker.visible:
			continue
		if nearest_marker == null:
			nearest_marker = marker
			nearest_distance = marker.global_position.distance_to(player.global_position)
		else:
			var distance_to_marker = marker.global_position.distance_to(player.global_position)
			if distance_to_marker < nearest_distance:
				nearest_marker = marker
				nearest_distance = distance_to_marker
	
	
	if nearest_distance != null and nearest_distance < marker_select_range:
		if selected_marker != nearest_marker:
			if selected_marker != null:
				selected_marker.material.set_shader_param("power", default_marker_glow_power)
			selected_marker = nearest_marker
		selected_marker.material.set_shader_param("power", marker_glow_power)
	elif selected_marker != null:
		selected_marker.material.set_shader_param("power", default_marker_glow_power)
		selected_marker = null
#
#	if nearest_marker != null and selected_marker != nearest_marker:
#		if selected_marker != null:
#			selected_marker.material.set_shader_param("power", default_marker_glow_power)
#		selected_marker = nearest_marker 
#
#	if nearest_distance < marker_glow_range:
#		selected_marker.material.set_shader_param("power", marker_glow_power)
#	else:
#		selected_marker.material.set_shader_param("power", default_marker_glow_power)
#
#		var glow_power = clamp(40 / delta_position.length(), 0.2, 5.0)
#		if glow_power > 1:
#			glow_power = 3.0
#			active_building = building
#		building.material.set_shader_param("power", glow_power)
#		print('building.material.set_shader_param("power", ', glow_power, ')')
	
# Called when the node enters the scene tree for the first time.
func _ready():
	marker_nodes = $map/markers.get_children()
	player = $map/player
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	select_nearest_building()

