class_name RespawnPoint
extends Area3D


func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		body.respawn_point = global_position
