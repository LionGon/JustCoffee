shader_type canvas_item;

uniform float flicker_speed : hint_range(0.0, 10.0) = 4.0;
uniform float flicker_strength : hint_range(0.0, 1.0) = 0.28;
uniform float breathe_strength : hint_range(0.0, 0.02) = 0.003;
uniform float breathe_speed : hint_range(0.0, 1.0) = 0.18;

void fragment() {
	vec2 uv = UV;
	float t_breathe = TIME * breathe_speed;
	vec2 breathe_offset = vec2(sin(t_breathe), cos(t_breathe * 0.7)) * breathe_strength;
	vec4 base = texture(TEXTURE, uv + breathe_offset);
	float wave = sin(TIME * flicker_speed) * 0.5 + sin(TIME * flicker_speed * 2.3) * 0.35;
	float lamp_mask = smoothstep(0.55, 0.22, distance(uv, vec2(0.5, 0.16)));
	float intensity = 1.0 + wave * flicker_strength * (0.35 + lamp_mask * 0.65);
	COLOR = vec4(base.rgb * intensity, base.a);
}
