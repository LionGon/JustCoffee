shader_type canvas_item;
render_mode blend_mix;

uniform float steam_strength : hint_range(0.0, 0.08) = 0.018;
uniform float steam_speed : hint_range(0.0, 2.0) = 0.38;
uniform sampler2D cafe_texture : repeat_disable, filter_linear;

float noise(vec2 p) {
	return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

float box_mask(vec2 uv, vec2 min_corner, vec2 max_corner, float feather) {
	float x = smoothstep(min_corner.x, min_corner.x + feather, uv.x)
		* smoothstep(max_corner.x, max_corner.x - feather, uv.x);
	float y = smoothstep(min_corner.y, min_corner.y + feather, uv.y)
		* smoothstep(max_corner.y, max_corner.y - feather, uv.y);
	return x * y;
}

void fragment() {
	vec2 uv = UV;
	float machine_steam = box_mask(uv, vec2(0.58, 0.28), vec2(0.88, 0.58), 0.06);
	float cup_steam = box_mask(uv, vec2(0.12, 0.48), vec2(0.38, 0.72), 0.05) * 0.28;
	float steam_mask = max(machine_steam, cup_steam);
	if (steam_mask < 0.05) {
		discard;
	}
	float t = TIME * steam_speed;
	float n = noise(uv * 10.0 + vec2(0.0, t));
	float n2 = noise(uv * 20.0 - vec2(t * 0.4, 0.0));
	vec2 offset = vec2(n - 0.5, n2 - 0.62) * steam_strength * steam_mask;
	vec4 sample_color = texture(cafe_texture, uv + offset);
	float shimmer = sin(t * 4.0 + uv.x * 30.0) * 0.022 * steam_mask;
	vec3 warm = sample_color.rgb + vec3(shimmer * 0.6, shimmer * 0.35, shimmer * 0.08);
	COLOR = vec4(warm, clamp(0.12 + steam_mask * 0.22, 0.0, 0.38));
}
