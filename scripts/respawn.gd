class_name RespawnPoint
extends Area3D


func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		EnemyManager.save_all_enemies()
		body.respawn_point = global_position
