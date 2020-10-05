extends MarginContainer

export (Color) var color_on_decrease = Color(1, 0, 0, 1)
export (Color) var color_on_increase = Color(0, 1, 0, 1)
var normal_color = Color(1, 1, 1, 1)
export (float) var color_keep_factor = 0.01

func merge_colors(base_color: Color, hint_color: Color, hint_power: float) -> Color:
	return base_color * (1 - hint_power) + hint_color * hint_power

func update_bar_value(bar: ProgressBar, new_value: float):
	var old_value = bar.value
	bar.value = new_value
	var delta = clamp((new_value - old_value) / 30, -0.5, 0.5)
	
	var color_modulate = bar.modulate
	if delta > 0:
		bar.modulate = merge_colors(color_modulate, color_on_increase, 0.5 + delta)
	elif delta < 0:
		bar.modulate = merge_colors(color_modulate, color_on_decrease, 0.5 - delta)

func render():
	update_bar_value($vbox/bars/money, GameStatus.money)
	update_bar_value($vbox/bars/stress, GameStatus.stress)
	update_bar_value($vbox/bars/family, GameStatus.family)
# Called when the node enters the scene tree for the first time.
func _ready():
	render()
	GameStatus.connect("resources_changed", self, 'render')

func return_bar_modulate(bar: ProgressBar, delta: float):
	var keep_factor = pow(color_keep_factor, delta)
	bar.modulate = merge_colors(normal_color, bar.modulate, keep_factor)

func _process(delta):
	return_bar_modulate($vbox/bars/money, delta)
	return_bar_modulate($vbox/bars/stress, delta)
	return_bar_modulate($vbox/bars/family, delta)
