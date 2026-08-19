shader_type canvas_item;

uniform vec4 color_top : source_color = vec4(0.0196, 0.0275, 0.0667, 1.0);
uniform vec4 color_bottom : source_color = vec4(0.0314, 0.0745, 0.1608, 1.0);
uniform vec4 accent_a : source_color = vec4(0.1686, 0.9059, 1.0, 1.0);
uniform vec4 accent_b : source_color = vec4(0.5451, 0.3608, 1.0, 1.0);
uniform float haze_strength : hint_range(0.0, 0.35) = 0.10;
uniform float star_strength : hint_range(0.0, 1.0) = 0.42;
uniform float time_scale : hint_range(0.0, 2.0) = 0.25;

float hash21(vec2 p) {
	p = fract(p * vec2(123.34, 345.45));
	p += dot(p, p + 34.345);
	return fract(p.x * p.y);
}

float value_noise(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);
	f = f * f * (3.0 - 2.0 * f);
	float a = hash21(i);
	float b = hash21(i + vec2(1.0, 0.0));
	float c = hash21(i + vec2(0.0, 1.0));
	float d = hash21(i + vec2(1.0, 1.0));
	return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

void fragment() {
	vec2 uv = UV;
	vec4 base = mix(color_top, color_bottom, smoothstep(0.0, 1.0, uv.y));
	float haze = value_noise(uv * 3.2 + vec2(TIME * time_scale * 0.05, 0.0));
	float haze2 = value_noise(uv * 6.5 - vec2(0.0, TIME * time_scale * 0.035));
	float haze_mask = smoothstep(0.42, 0.85, haze * 0.72 + haze2 * 0.28);
	vec4 haze_color = mix(accent_a, accent_b, smoothstep(0.15, 0.85, uv.x));
	base.rgb += haze_color.rgb * haze_mask * haze_strength;

	vec2 star_grid = floor(uv * vec2(140.0, 240.0));
	float star_seed = hash21(star_grid);
	float star = step(0.9935, star_seed);
	float twinkle = 0.65 + 0.35 * sin(TIME * (1.2 + star_seed * 2.0) + star_seed * 40.0);
	base.rgb += vec3(star * twinkle * star_strength);
	COLOR = base;
}
