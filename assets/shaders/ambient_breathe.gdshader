shader_type canvas_item;

uniform float breathe_strength : hint_range(0.0, 0.04) = 0.012;
uniform float breathe_speed : hint_range(0.0, 1.0) = 0.2;

void fragment() {
	vec2 uv = UV;
	float t = TIME * breathe_speed;
	vec2 offset = vec2(sin(t), cos(t * 0.7)) * breathe_strength;
	COLOR = texture(TEXTURE, uv + offset);
}
