extends Label

var time: float:
	set(value):
		time = value
		time_to_clock()
var min: int
var sec: int
var mil: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func time_to_clock() -> void:
	min = (int(time) / 60) % 60
	sec = int(time) % 60
	mil = int((time) * 1000) % 1000
	
	
		
	text\
		= time_to_string(min) + ":"\
		+ time_to_string(sec) + ":"\
		+ str(mil)

func time_to_string(time: int) -> String:
	var new_text := str(time)
	if time < 10:
		new_text = "0" + new_text
	return new_text
