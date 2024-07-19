extends CanvasLayer

@onready var texture: TextureRect = %TextureRect

func set_texture_offset(new_offset):
	texture.material.set_shader_parameter("offset", new_offset)
