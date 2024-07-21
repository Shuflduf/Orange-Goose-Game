extends PlayerSound

@onready var groan_timer: Timer = $GroanTimer

const ZOMBIE_SOUNDS = {
	"Hurt": "res://assets/sounds/zombie/hurt/",
	"Say": "res://assets/sounds/zombie/say/"
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	groan_timer.start(randi_range(7, 14))
	groan_timer.timeout.connect(func() -> void:
		if get_parent().target == null:
			return
		ambience.stream = load(random_sound_from_dir(ZOMBIE_SOUNDS["Say"]))
		ambience.play()
		groan_timer.start(randi_range(7, 14))
		)


func die() -> void:
	stream = load(random_sound_from_dir(ZOMBIE_SOUNDS["Hurt"]))
	play()
