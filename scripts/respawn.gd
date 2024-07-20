class_name RespawnPoint
extends Area3D

@export var camera_height: float

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		EnemyManager.save_all_enemies()
		body.respawn_point = global_position
		body.world_offset = camera_height
