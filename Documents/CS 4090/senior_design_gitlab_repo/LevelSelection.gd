extends OptionButton

var loop_var = false
var files_index = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func list_files_in_directory(path):
	var files = ["DoNotClick"]
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with(".") && file.ends_with(".tscn"):
			files.append(file)
	dir.list_dir_end()

	return files


func _on_LevelSelection_pressed():
	var files = list_files_in_directory("res://saves")
	if loop_var == false:
		for i in files:
			add_item(files[files_index])
			files_index += 1
		loop_var = true




func _on_LevelSelection_item_selected(index):
	var files = list_files_in_directory("res://saves")
	
	get_tree().change_scene("res://game_simulator.tscn")
	global.professor_mode = false
	global.play_mode = true
	
	#load in scene gates
	var packed_scene = load("res://saves/"+files[index])
		
		#clear out any gates currently in the scene
		
	var imported_scene = packed_scene.instance()
		
	for gate in imported_scene.get_children():
		if gate.is_in_group("gates"):
			imported_scene.remove_child(gate)
			get_tree().get_root().add_child(gate)

