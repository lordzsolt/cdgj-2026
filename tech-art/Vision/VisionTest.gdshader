shader_type canvas_item;

uniform sampler2D screen_texture : source_color;
uniform sampler2D vision_texture : source_color;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR = texture(screen_texture, UV).rgba;
	COLOR = texture(vision_texture, UV).r * texture(screen_texture, UV).rgba;
}

