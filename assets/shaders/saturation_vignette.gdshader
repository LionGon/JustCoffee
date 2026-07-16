shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear;
uniform float saturation_level : hint_range(0.0, 1.0) = 0.0;
uniform bool post_elena_state = false;

const float CLEAR_FOV_AT_MAX = 0.60;
const float WARM_COOL_MAX = 0.18;
const vec3 LUMA_WEIGHTS = vec3(0.2126, 0.7152, 0.0722);
const float MONOCHROME_CAP = 0.97;

// ISSUE-302: quadratic base + high-band boost — 0.5 stays readable, 0.85 near-monochrome.
float desaturation_amount(float level) {
	float base = level * level;
	float high_boost = smoothstep(0.65, 0.85, level) * 0.45;
	return clamp(base + high_boost, 0.0, MONOCHROME_CAP);
}

vec3 luminance_desaturate(vec3 rgb, float amount) {
	float luma = dot(rgb, LUMA_WEIGHTS);
	vec3 grey = vec3(luma);
	grey.r -= luma * 0.025 * amount;
	grey.g -= luma * 0.012 * amount;
	grey.b += luma * 0.038 * amount;
	return mix(rgb, grey, amount);
}

void fragment() {
	vec4 color = texture(screen_texture, SCREEN_UV);
	float level = clamp(saturation_level, 0.0, 1.0);

	float desat_amount = desaturation_amount(level);
	vec3 base = luminance_desaturate(color.rgb, desat_amount);

	vec2 centered = SCREEN_UV * 2.0 - 1.0;
	float dist = length(centered);
	float inner = mix(1.8, CLEAR_FOV_AT_MAX, level);
	float outer = mix(1.8, 1.05, level);
	float vignette_mask = smoothstep(inner, outer, dist);

	float vignette_strength = vignette_mask * level;
	if (post_elena_state) {
		vignette_strength *= 0.88;
	}
	vec3 result = mix(base, base * mix(1.0, 0.12, level), vignette_strength);

	float cool_blend = smoothstep(0.3, 0.75, level) * WARM_COOL_MAX;
	if (post_elena_state) {
		cool_blend *= 0.45;
	}
	float warmth = clamp(
		dot(normalize(result + vec3(0.001)), vec3(0.55, 0.35, 0.10)),
		0.0,
		1.0
	);
	result.r *= 1.0 - cool_blend * warmth;
	result.g *= 1.0 - cool_blend * warmth * 0.55;
	result.b *= 1.0 + cool_blend * (1.0 - warmth) * 0.12;

	COLOR = vec4(result, color.a);
}
