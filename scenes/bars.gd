extends MarginContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#onready var money_bar = 
#export (float) var money = 100 setget _set_money
#
#func _set_money(new_money):
#	money_bar
#	pass

func render():
	$vbox/bars/money.value = GameStatus.money
	$vbox/bars/stress.value = GameStatus.stress
	$vbox/bars/family.value = GameStatus.family
# Called when the node enters the scene tree for the first time.
func _ready():
	render()
	GameStatus.connect("resources_changed", self, 'render')


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
