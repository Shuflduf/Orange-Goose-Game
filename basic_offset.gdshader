shader_type canvas_item;

uniform float offset;  // Offset parameter to move the image

void vertex() {
  UV.x += offset;  // Wrap uv coordinates around (repeat)
}

void fragment() {
  COLOR = texture(TEXTURE, UV);  // Sample the texture using wrapped uv
}
