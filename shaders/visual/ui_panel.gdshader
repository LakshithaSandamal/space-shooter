shader_type canvas_item;

uniform vec4 panel_color : source_color = vec4(0.067, 0.102, 0.192, 0.94);
uniform vec4 edge_color : source_color = vec4(0.153, 0.906, 1.0, 0.34);
uniform float scanline_strength : hint_range(0.0, 0.15) = 0.025;
uniform float edge_strength : hint_range(0.0, 1.0) = 0.30;
uniform float time_scale : hint_range(0.0, 4.0) = 0.35;

void fragment() {
	vec4 source = texture(TEXTURE, UV);
	float border_distance = min(min(UV.x, 1.0 - UV.x), min(UV.y, 1.0 - UV.y));
	float edge = 1.0 - smoothstep(0.0, 0.035, border_distance);
	float scan = 0.5 + 0.5 * sin((UV.y + TIME * time_scale) * 720.0);
	vec3 rgb = panel_color.rgb + edge_color.rgb * edge * edge_strength;
	rgb += edge_color.rgb * scan * scanline_strength;
	float alpha = max(source.a, panel_color.a);
	COLOR = vec4(rgb, alpha);
}
