extends Control

@onready var health_ui: Panel = $HealthUI
@onready var timer: Label = $Timer
@onready var pause: Control = $Pause
@onready var win_screen: Control = $WinScreen

signal pause_state(paused: bool)
signal main_menu
signal reload


func win() -> void:
	win_screen.show()
	pause.hide()
