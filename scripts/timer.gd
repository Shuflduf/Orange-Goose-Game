extends Label

var time: float = 0.0:
	set(value):
		time = value
		time_to_clock()
var minn: int
var sec: int
var mil: int

func time_to_clock() -> void:
	minn = int((time) / 60) % 60
	sec = int(time) % 60
	mil = int((time) * 1000) % 1000
		
	text\
		= time_to_string(minn) + ":"\
		+ time_to_string(sec) + ":"\
		+ str(mil)

func time_to_string(new_time: int) -> String:
	var new_text := str(new_time)
	if new_time < 10:
		new_text = "0" + new_text
	return new_text
