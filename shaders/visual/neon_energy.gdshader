shader_type canvas_item;
render_mode unshaded;

uniform vec4 energy_color : source_color = vec4(0.153, 0.906, 1.0, 1.0);
uniform float intensity : hint_range(0.0, 3.0) = 1.0;
uniform float pulse_speed : hint_range(0.0, 12.0) = 3.0;
uniform float edge_power : hint_range(0.5, 8.0) = 2.5;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	float pulse = 0.82 + 0.18 * sin(TIME * pulse_speed);
	float edge = pow(clamp(tex.a, 0.0, 1.0), 1.0 / edge_power);
	vec3 rgb = mix(tex.rgb, energy_color.rgb, 0.72) * intensity * pulse;
	COLOR = vec4(rgb, edge * tex.a * energy_color.a);
}
