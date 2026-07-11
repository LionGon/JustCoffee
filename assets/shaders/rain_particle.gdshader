shader_type canvas_item;
render_mode blend_mix;

uniform float rain_density : hint_range(0.0, 1.0) = 0.75;
uniform float rain_speed : hint_range(0.0, 5.0) = 2.5;
uniform vec4 rain_color : source_color = vec4(0.78, 0.84, 0.92, 0.45);

float hash(vec2 p) {
	return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

void fragment() {
	vec2 uv = UV;
	float t = TIME * rain_speed;
	float column = floor(uv.x * 200.0);
	float seed = hash(vec2(column, 0.0));
	float y = fract(uv.y - t * (0.9 + seed * 1.1) + seed);
	// Thin streaks — not chunky bars.
	float streak = smoothstep(0.0, 0.008, y) * smoothstep(0.06, 0.008, y);
	float alpha = streak * rain_density * (0.35 + seed * 0.65);
	COLOR = vec4(rain_color.rgb, rain_color.a * alpha);
}
