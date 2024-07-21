extends Control

@export_file("*.tscn") var game_scene: String


func _on_start_pressed() -> void:
	SceneManager.transition_to(game_scene)


func _on_quit_pressed() -> void:
	get_tree().quit()
