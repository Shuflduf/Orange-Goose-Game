extends Node

var all_enemies: Array[CharacterBody3D]

func save_all_enemies():
	all_enemies.clear()
	for i in get_tree().get_nodes_in_group("Enemy"):
		all_enemies.append(i.duplicate())

func load_all_enemies():
	for i in get_tree().get_nodes_in_group("Enemy"):
		i.queue_free()
		
	for i in all_enemies:
		var enemy_parent = get_tree().root.find_child("Enemies", true, false)
		enemy_parent.add_child(i)
