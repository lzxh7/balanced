shader_type canvas_item;

void fragment() {
	COLOR = int(TIME * 5.0) % 2 == 0 ? vec4(1, 0, 0, texture(TEXTURE, UV).a) : texture(TEXTURE, UV);
}
