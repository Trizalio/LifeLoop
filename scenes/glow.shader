shader_type canvas_item;

uniform vec4 selected_glow: hint_color;
uniform int max_steps = 5;
uniform float shift_per_step = 1;
uniform float pulse_frequency = 5.;
uniform float power = 2.;

float get_alpha_from_texture(sampler2D tex, vec2 uv){
	if (uv.x >= 1. || uv.y >= 1. || uv.x <= 0. || uv.y <= 0.){
		return 0.;
	}
	return texture(tex, uv).a;
}

vec4 get_color_from_texture(sampler2D tex, vec2 uv){
	if (uv.x >= 1. || uv.y >= 1. || uv.x <= 0. || uv.y <= 0.){
		return vec4(0.);
	}
	return texture(tex, uv);
}

float get_mixed(sampler2D tex, vec2 uv, vec2 shift){
	float result = 0.;
	result += get_alpha_from_texture(tex, uv + vec2(-shift.x, 0.));
	result += get_alpha_from_texture(tex, uv + vec2(shift.x, 0.));
	result += get_alpha_from_texture(tex, uv + vec2(shift));
	result += get_alpha_from_texture(tex, uv + vec2(-shift));
	result += get_alpha_from_texture(tex, uv + vec2(-shift.x, shift.y));
	result += get_alpha_from_texture(tex, uv + vec2(shift.x, -shift.y));
	result += get_alpha_from_texture(tex, uv + vec2(0., shift.y));
	result += get_alpha_from_texture(tex, uv + vec2(0., -shift.y));
	result /= 8.;
	return result;
}

void fragment(){
	float extension = shift_per_step * float(max_steps) * 1.;
	vec2 texture_size = vec2(textureSize(TEXTURE, 0));
	vec2 real_size = texture_size + vec2(extension * 2.);
	vec2 local_position = UV * real_size - vec2(extension) ;
	vec2 uv = local_position / texture_size / 1.;
	float current_power = power * (2. + sin(TIME * pulse_frequency));
	COLOR = get_color_from_texture(TEXTURE, uv);
	if (COLOR.a < 1.){
		float free_alpha = 1. - COLOR.a;
		float fade_factor = 0.;
		for(int i = 0; i < max_steps; i++){
			vec2 shift = float(i + 1) * shift_per_step / texture_size;
			fade_factor += get_mixed(TEXTURE, uv, shift);
		}
		fade_factor /= float(max_steps);
		fade_factor *= current_power;

		float missing_alpha = 1. - COLOR.a;
		fade_factor = clamp(fade_factor, 0., missing_alpha);
		float total_alpha = COLOR.a + fade_factor;
		vec3 color = mix(COLOR.rgb, selected_glow.rgb, fade_factor / total_alpha);
		COLOR = vec4(color.rgb, total_alpha);
		COLOR.a = fade_factor;
	}
//	if (uv.x < 0.){
//		COLOR.a = 0.;
//	}
}

void vertex() {
	float extension = shift_per_step * float(max_steps) * 1.;
//	vec2 shift = vec2(0.);
//	vec4 color = vec4(0.);
//	extension = 0.;

//	VERTEX.x += 2. * extension * UV.x - extension;
//	VERTEX.y += 2. * extension * UV.y - extension;
	VERTEX += 2. * extension * UV - extension;
//	COLOR.a -= 0.1;
}