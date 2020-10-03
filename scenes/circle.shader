shader_type canvas_item;

uniform vec4 selected_color: hint_color;

void fragment() {
	vec4 tex = textureLod(TEXTURE, UV, 0.0);
	COLOR = vec4(selected_color.rgb, 0);
	float x = (UV.x - 0.5) * 2.;
	float y = (UV.y - 0.5) * 2.;
	float r = x * x + y * y;
	if (r < 1.){
		COLOR.a = 1.
	}
}