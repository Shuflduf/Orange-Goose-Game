
extends Control

@onready var ui: Control = $".."

func _ready() -> void:
	hide()


func _on_main_menu_pressed() -> void:
	ui.main_menu.emit()


func _on_restart_pressed() -> void:
	ui.reload.emit()
