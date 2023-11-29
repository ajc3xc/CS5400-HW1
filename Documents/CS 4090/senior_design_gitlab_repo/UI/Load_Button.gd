extends "res://UI/set_visibility.gd"



func _ready():
	pass # Replace with function body.





func _on_LineEdit_text_entered(new_text):
	var scene_name = new_text
	var fileToCheck = File.new()
	var fileExists = fileToCheck.file_exists("res://saves/"+scene_name+".tscn")
	if fileExists:
		
		#switch to game simulator scene
		get_tree().change_scene("res://game_simulator.tscn")
		
		#clear out any gates currently in the scene

		for child in get_tree().get_root().get_children():
			if child.is_in_group("gates") or child.name == "save_node":
				get_tree().get_root().remove_child(child)
				child.queue_free()

		
		#load in scene gates
		var packed_scene = load("res://saves/"+scene_name+".tscn")
		
		#clear out any gates currently in the scene
		
		var imported_scene = packed_scene.instance()
		
		for gate in imported_scene.get_children():
			if gate.is_in_group("gates"):
				imported_scene.remove_child(gate)
				get_tree().get_root().add_child(gate)

		
	else:
		print("Invalid Scene")
