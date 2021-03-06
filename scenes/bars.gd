extends MarginContainer

export (Color) var color_on_decrease = Color(1, 0, 0, 1)
export (Color) var color_on_increase = Color(0, 1, 0, 1)
var normal_color = Color(1, 1, 1, 1)
export (float) var color_keep_factor = 0.01

func merge_colors(base_color: Color, hint_color: Color, hint_power: float) -> Color:
	return base_color * (1 - hint_power) + hint_color * hint_power

func update_bar_value(bar: ProgressBar, new_value: float, glow_on_change: bool = true):
	var old_value = bar.value
	bar.value = new_value
	var delta = clamp((new_value - old_value) / 30, -0.5, 0.5)
	
	if not glow_on_change:
		return
		
	var color_modulate = bar.modulate
	if delta > 0:
		bar.modulate = merge_colors(color_modulate, color_on_increase, 0.5 + delta)
	elif delta < 0:
		bar.modulate = merge_colors(color_modulate, color_on_decrease, 0.5 - delta)

func render_bars(glow_on_change: bool = true):
	update_bar_value($vbox/bars/money, GameStatus.money, glow_on_change)
	update_bar_value($vbox/bars/stress, GameStatus.stress, glow_on_change)
	update_bar_value($vbox/bars/family, GameStatus.family, glow_on_change)
	
func render_time():
	$vbox/time/label.text = "%0*d:00" % [2, GameStatus.current_time_step]
func _ready():
	render_bars(false)
	render_time()
	GameStatus.connect("resources_changed", self, 'render_bars')
	GameStatus.connect("time_step_changed", self, 'render_time')

func return_bar_modulate(bar: ProgressBar, delta: float):
	var keep_factor = pow(color_keep_factor, delta)
	bar.modulate = merge_colors(normal_color, bar.modulate, keep_factor)

func _process(delta):
	return_bar_modulate($vbox/bars/money, delta)
	return_bar_modulate($vbox/bars/stress, delta)
	return_bar_modulate($vbox/bars/family, delta)
