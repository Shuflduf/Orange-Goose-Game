extends Node


var enemy_save: String

func save_all_enemies():
	enemy_save = ""
	for i in get_tree().get_nodes_in_group("Enemy"):
		
		var save_dict = {
			"filename" : i.get_scene_file_path(),
			"position.x" : i.position.x,
			"position.y" : i.position.y
		}
		
		var jsoned_data = JSON.stringify(save_dict)
		enemy_save += jsoned_data
		enemy_save += "\n"

	
func load_all_enemies():
	
	# Remove all current enemies in tree
	for i in get_tree().get_nodes_in_group("Enemy"):
		i.queue_free()
	
	var enemy_parent = get_tree().root.find_child("Enemies", true, false)
	
	
	# Loop over every line in the save string
	for enemy_data in enemy_save.split("\n"):
		if enemy_data == "":
			return
			
		# Create a helper JSON class
		var json = JSON.new()
		
		# PARSE THE STRING INTO A DICTIONARY
		var parse_result = json.parse(enemy_data)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", enemy_data, " at line ", json.get_error_line())
			continue
			
		# Get the data from the helper JSON class
		var data = json.get_data()
		
		# Create a new enemy with the data 
		var new_enemy = load(data["filename"]).instantiate()
		new_enemy.position = Vector3(
			data["position.x"],
			data["position.y"], 0
		)
		enemy_parent.add_child(new_enemy)
