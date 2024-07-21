extends AudioStreamPlayer3D

enum blockType {
	Grass,
	Dirt,
	Stone,
	Wood,
	OTHER
	}

const SOUNDS = {
	blockType.Grass: "res://assets/sounds/step/grass/",
	blockType.Dirt: "res://assets/sounds/step/dirt/",
	blockType.Stone: "res://assets/sounds/step/stone/",
	blockType.Wood: "res://assets/sounds/step/wood/",
	blockType.OTHER: null,
	}

var current_block_type: blockType

func play_r_pitch(deviation: float) -> void:
	pitch_scale = 1
	pitch_scale = randf_range(1 - deviation, 1 + deviation)
	play()

func match_block_name(block_name: String) -> void:
	var type: blockType
	match block_name:
		"Grass":
			type = blockType.Grass
		"Dirt":
			type = blockType.Dirt
		"Stone", "Cobblestone", "SmoothStone", "Granite", "Diorite":
			type = blockType.Stone
		"WoodPlank", "WoodPlankStair", "WoodSlab":
			type = blockType.Wood
		_:
			type = blockType.OTHER
	random_sound_from_dir(SOUNDS[type])

func random_sound_from_dir(path: String) -> void:
	var dir := DirAccess.open(path)
	var rand_index := randi_range(0, dir.get_files().size() - 1) / 2
	print(dir.get_files()[rand_index * 2])
	#stream = load(dir.get_files()[0])
