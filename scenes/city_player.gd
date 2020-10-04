extends KinematicBody2D

var velocity  = Vector2()
var friction_factor = 0.85
var destination = null
export (float) var speed = 200

signal destination_reached

func _ready():
	velocity = Vector2()
	
func move_to_destination(destination_position: Vector2):
	print('move_to_destination')
	destination = destination_position

func blink_to_destination(destination_position: Vector2):
	position = destination_position
	
func autopilot() -> Vector2:
	var delta = destination - position
	if delta.length() < speed * 0.1:
		destination = null
		emit_signal("destination_reached")
	return delta.normalized() * speed
	
func get_input() -> Vector2:
	var direction = Vector2()
	if Input.is_action_pressed('ui_right'):
		direction.x += 1
	if Input.is_action_pressed('ui_left'):
		direction.x -= 1
	if Input.is_action_pressed('ui_down'):
		direction.y += 1
	if Input.is_action_pressed('ui_up'):
		direction.y -= 1
	direction = direction.normalized() * speed
	return direction

func face_direction(direction: Vector2):
	var main_direction_is_x =  abs(direction.x) > abs(direction.y)
	var sprite = $Sprite
	if main_direction_is_x:
		sprite.animation = 'side'
		if direction.x < 0 and sprite.scale.x > 0:
			sprite.scale.x *= -1
		if direction.x > 0 and sprite.scale.x < 0:
			sprite.scale.x *= -1
	else:
		if direction.y > 0:
			sprite.animation = 'up'
		else:
			sprite.animation = 'down'

func _physics_process(delta):
	var direction: Vector2
	if destination != null:
		direction = autopilot()
	else:
		direction = get_input()
	velocity = direction * (1 - friction_factor) + velocity * friction_factor
	face_direction(velocity)
#	move_and_collide(velocity * delta)
	move_and_slide(velocity)
