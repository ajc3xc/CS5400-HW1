extends "res://Gates/dropdown/drop_down_menu.gd"

var gateType = "AND"

func set_nodes_to_enable():
	in_nodes = 2
	out_nodes = 1

func set_sprite():
	bullet_sprite.set_texture(AND)

#used in inhereited nodes
func _check_if_type_correct():
	isCorrect = (selectedType == gateType)
