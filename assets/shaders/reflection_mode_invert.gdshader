shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear;
uniform bool reflection_active = false;

const vec3 LUMA_WEIGHTS = vec3(0.2126, 0.7152, 0.0722);
const vec3 THERMAL_COOL = vec3(0.06, 0.20, 0.58);
const vec3 THERMAL_WARM = vec3(1.0, 0.34, 0.08);

void fragment() {
	vec4 screen_color = texture(screen_texture, SCREEN_UV);
	if (!reflection_active) {
		COLOR = screen_color;
	} else {
		vec3 inverted = vec3(1.0) - screen_color.rgb;
		float inverted_luma = dot(inverted, LUMA_WEIGHTS);
		vec3 thermal_palette = mix(THERMAL_COOL, THERMAL_WARM, smoothstep(0.12, 0.88, inverted_luma));
		vec3 result = mix(inverted, thermal_palette, 0.68);
		COLOR = vec4(result, screen_color.a);
	}
}
