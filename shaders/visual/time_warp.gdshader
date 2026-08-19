shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear;
uniform vec4 tint : source_color = vec4(0.545, 0.361, 1.0, 1.0);
uniform float strength : hint_range(0.0, 0.08) = 0.018;
uniform float ring_frequency : hint_range(2.0, 40.0) = 16.0;
uniform float speed : hint_range(0.0, 8.0) = 1.8;

void fragment() {
	vec2 centered = SCREEN_UV - vec2(0.5);
	float radius = length(centered);
	vec2 direction = radius > 0.0001 ? centered / radius : vec2(0.0);
	float wave = sin(radius * ring_frequency - TIME * speed) * strength;
	vec2 warped_uv = SCREEN_UV + direction * wave * smoothstep(0.75, 0.05, radius);
	vec4 scene = texture(screen_texture, warped_uv);
	float ring = 0.5 + 0.5 * sin(radius * ring_frequency - TIME * speed);
	scene.rgb += tint.rgb * ring * 0.055 * smoothstep(0.72, 0.08, radius);
	COLOR = scene;
}
