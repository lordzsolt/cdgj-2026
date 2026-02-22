shader_type canvas_item;

uniform sampler2D level_texture : source_color;
uniform float vignette_size : hint_range(0.0, 2.0) = 0.5;
uniform float vignette_smoothness : hint_range(0.0, 1.0) = 0.5;
uniform float pulse_speed : hint_range(0.0, 10.0) = 2.0;
uniform float pulse_intensity : hint_range(0.0, 1.0) = 0.1;

void fragment() {
	// Sample the level texture
	vec4 level = texture(level_texture, SCREEN_UV).rgba;
	
	// Calculate distance from center
	float dist = distance(UV, vec2(0.5));
	
	// 1. Map sin from [-1, 1] to [0, 1]
	// 2. Use that to oscillate between (Size - Intensity) and (Size + Intensity)
	float pulse = sin(TIME * pulse_speed) * pulse_intensity;
	float dynamic_size = vignette_size + pulse;
	
	// Create the vignette mask using the dynamic size
	float vignette = smoothstep(dynamic_size, dynamic_size - vignette_smoothness, dist);
	
	vec4 red = vec4(1.0, 0.0, 0.0, 1.0);
	
	// Apply the vignette: red where vignette is 0.0, level where it is 1.0
	COLOR = mix(red, level, vignette);
}