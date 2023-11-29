extends "set_visibility.gd"

# Called when the node enters the scene tree for the first time.
func _ready():
	game_mode_ui = true




func _on_Button_pressed():
	var allCorrect = true
	
	for child in get_tree().get_nodes_in_group("dropdown"):
		print("Gate Type: "+str(child.gateType)+\
		", Selected Type: "+str(child.selectedType)+", Correct: "+str(child.isCorrect))
		if not child.isCorrect:
			allCorrect = false
			
	print(allCorrect)
