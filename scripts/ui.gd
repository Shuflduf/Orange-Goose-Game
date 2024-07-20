extends Control

@onready var health_ui: Panel = $HealthUI
@onready var timer: Label = $Timer
@onready var pause: Control = $Pause

signal pause_state(paused: bool)
signal main_menu

