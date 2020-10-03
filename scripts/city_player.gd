extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
var motion = null
const SPEED = 250

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	motion = Vector2()
	var sprite = get_node("Sprite")
	
	if Input.is_action_pressed("ui_up"):
		motion += Vector2(0,-1)
		sprite.animation = 'up'
	elif Input.is_action_pressed("ui_down"):
		motion += Vector2(0,1)
		sprite.animation = 'down'
	elif Input.is_action_pressed("ui_left"):
		motion += Vector2(-1,0)
		sprite.animation = 'side'
		if sprite.scale.x > 0:
			sprite.scale.x *= -1
	elif Input.is_action_pressed("ui_right"):
		motion += Vector2(1,0)
		sprite.animation = 'side'
		if sprite.scale.x < 0:
			sprite.scale.x *= -1
	
	position += motion * delta * SPEED
#	var size = get_viewport_rect().size
	
#	pos.x = clamp (pos.x,0,size.x)
#	pos.y = clamp (pos.y,0,size.y)
	
#	set_pos(pos)
	pass
