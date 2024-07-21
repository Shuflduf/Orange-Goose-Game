class_name PlayerSound
extends AudioStreamPlayer3D

@onready var ambience: AudioStreamPlayer3D = $Ambience

enum blockType {
	Grass,
	Dirt,
	Stone,
	Wood,
	OTHER
	}

const STEP_SOUNDS = {
	blockType.Grass: "res://assets/sounds/step/grass/",
	blockType.Dirt: "res://assets/sounds/step/dirt/",
	blockType.Stone: "res://assets/sounds/step/stone/",
	blockType.Wood: "res://assets/sounds/step/wood/",
	blockType.OTHER: null,
	}
const WATER_SOUNDS = {
	"Enter": "res://assets/sounds/water/enter/",
	"Exit": "res://assets/sounds/water/exit/",
	"Ambience": "res://assets/sounds/water/ambience.ogg"
	}

const HURT_SOUNDS = "res://assets/sounds/player/hurt/"

const YIPEE = "res://assets/sounds/player/yippee-tbh.ogg"

var current_block_type: blockType

func step() -> void:
	stream = load(random_sound_from_dir(STEP_SOUNDS[current_block_type]))
	play()	
func match_block_name(block_name: String) -> void:
	match block_name:
		"Grass":
			current_block_type = blockType.Grass
		"Dirt":
			current_block_type = blockType.Dirt
		"Stone", "Cobblestone", "SmoothStone", "Granite", "Diorite":
			current_block_type = blockType.Stone
		"WoodPlank", "WoodPlankStair", "WoodSlab":
			current_block_type = blockType.Wood


func random_sound_from_dir(path: String) -> String:
	var dir := DirAccess.open(path)
	var file_path: String = path
	@warning_ignore("integer_division")
	var rand_index := randi_range(0, dir.get_files().size() - 1) / 2
	file_path += dir.get_files()[rand_index * 2]
	return file_path

func enter_water() -> void:
	stream = load(random_sound_from_dir(WATER_SOUNDS.Enter))
	play()
	ambience.stream = load(WATER_SOUNDS.Ambience)
	ambience.play()
func leave_water() -> void:
	stream = load(random_sound_from_dir(WATER_SOUNDS.Exit))
	play()
	ambience.stop()
