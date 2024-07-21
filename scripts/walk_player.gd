class_name WalkSound
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

func step() -> void:
	stream = load(random_sound_from_dir(SOUNDS[current_block_type]))
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
		#_:
			#current_block_type = blockType.OTHER
			
	#random_sound_from_dir(SOUNDS[current_block_type])

func random_sound_from_dir(path: String) -> String:
	var dir := DirAccess.open(path)
	var file_path: String = path
	@warning_ignore("integer_division")
	var rand_index := randi_range(0, dir.get_files().size() - 1) / 2
	file_path += dir.get_files()[rand_index * 2]
	return file_path
