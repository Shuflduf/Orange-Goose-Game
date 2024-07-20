
extends Control

@onready var ui: Control = $".."

func _ready() -> void:
	hide()

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		ui.pause_state.emit(!visible)
		visible = !visible
	
	
func _on_continue_pressed() -> void:
	visible = !visible
	ui.pause_state.emit(visible)
