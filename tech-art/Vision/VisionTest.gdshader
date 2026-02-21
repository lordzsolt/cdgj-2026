shader_type canvas_item;

uniform sampler2D level_texture : source_color;
uniform sampler2D vision_texture : source_color;
uniform sampler2D map_texture : source_color;
uniform float darkness = 0.1;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	//COLOR = texture(screen_texture, SCREEN_UV).rgba;
	float vision = texture(vision_texture, SCREEN_UV).r;
	vec4 level = texture(level_texture, SCREEN_UV).rgba;
	vec4 map = texture(map_texture, SCREEN_UV).rgba;
	vec4 black = vec4(0.0, 0.0, 0.0, 1.0);
	map = mix(black, map, darkness);
	COLOR = mix(map, level, vision);
	
	//COLOR = vec4(1.0, 0.0, 0.0, 1.0); // Debug red
}

