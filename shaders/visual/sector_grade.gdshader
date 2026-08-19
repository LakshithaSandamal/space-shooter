shader_type canvas_item;

uniform vec4 grade_color : source_color = vec4(0.545, 0.361, 1.0, 1.0);
uniform float grade_strength : hint_range(0.0, 0.35) = 0.08;
uniform float contrast : hint_range(0.7, 1.5) = 1.03;
uniform float vignette_strength : hint_range(0.0, 0.6) = 0.12;

void fragment() {
	vec4 base = texture(TEXTURE, UV);
	vec3 graded = mix(base.rgb, base.rgb * grade_color.rgb * 1.45, grade_strength);
	graded = (graded - vec3(0.5)) * contrast + vec3(0.5);
	vec2 centered = UV - vec2(0.5);
	float vignette = smoothstep(0.25, 0.78, length(centered));
	graded *= 1.0 - vignette * vignette_strength;
	COLOR = vec4(graded, base.a);
}
