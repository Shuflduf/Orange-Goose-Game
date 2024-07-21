
extends Control

@onready var ui: Control = $".."

func _ready() -> void:
	hide()

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if ui.win_screen.visible:
			return
		ui.pause_state.emit(!visible)
		visible = !visible
	
	
func _on_continue_pressed() -> void:
	visible = !visible
	ui.pause_state.emit(visible)


func _on_main_menu_pressed() -> void:
	ui.main_menu.emit()


func _on_restart_pressed() -> void:
	ui.reload.emit()
