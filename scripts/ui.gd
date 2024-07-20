extends Control

@onready var health_ui: Panel = $HealthUI
@onready var timer: Label = $Timer
@onready var pause: Control = $Pause

signal pause_state(paused: bool)

func _ready() -> void:
	pause_state.connect(func(state: bool) -> void:
		print(state))
