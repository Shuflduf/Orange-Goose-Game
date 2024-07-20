extends Node3D

@onready var backround: Sprite3D = $Backround
@onready var player: Player = $Player


@export_range(0, 1, 0.05) var parallax_effect := 0.6

var camera: Camera3D:
	get:
		return player.find_child("Camera3D")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	backround.position.x = camera.position.x
	backround.position.y = camera.position.y
	
	backround.material_override.uv1_offset.x = (camera.position.x / backround.scale.x) * (parallax_effect)


func _on_win_area_body_entered(body: Node3D) -> void:
	if body is Player:
		body.win()
