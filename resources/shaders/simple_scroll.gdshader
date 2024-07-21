shader_type canvas_item;

uniform vec2 speed_dir = vec2(1.0, 0.0);


void fragment() {
	COLOR = texture(TEXTURE, mod(UV + TIME * speed_dir, 1.0));
}
