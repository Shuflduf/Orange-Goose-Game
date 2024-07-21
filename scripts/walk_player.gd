extends AudioStreamPlayer3D


func play_r_pitch(deviation: float) -> void:
	pitch_scale = 1
	pitch_scale = randf_range(1 - deviation, 1 + deviation)
	play()
