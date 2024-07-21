extends Control

@export_file("*.tscn") var game_scene: String


func _on_start_pressed() -> void:
	print(SceneManager)
	SceneManager.transition_to(game_scene)
	


func _on_quit_pressed() -> void:
	get_tree().quit()
