extends "set_visibility.gd"


func _on_Button_pressed():
	#for child in get_node('../').get_children():
	for child in get_tree().root.get_children():
		recursively_remove_all_gates(child)

#recursion, son
func recursively_remove_all_gates(node: Node2D):
	#node is null
	if not node:
		return
	if node.is_in_group("gates"):
		node.remove_gate()
	elif len(node.get_children()) > 0:
		for child in node.get_children():
			recursively_remove_all_gates(child)
