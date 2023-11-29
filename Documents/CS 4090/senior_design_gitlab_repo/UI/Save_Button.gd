extends "res://UI/set_visibility.gd"

func _ready():
	pass # Replace with function body.




func _on_LineEdit_text_entered(save_file_name):
	#testing
	#save_file_dict()
	var new_scene = save_file_name
	var save_scene = PackedScene.new()
	var save_node = Node2D.new()
	save_node.name = "save_node"
	var saved_gates = []
	if new_scene != "":
		for child in get_tree().get_root().get_children():
			if child.is_in_group("gates"):
				#remove child from root node, add to save node
				get_tree().get_root().remove_child(child)
				save_node.add_child(child)
				saved_gates.append(child)

		
		#print(save_node.get_children())
		for gate in save_node.get_children():
			gate.set_owner(save_node)
			
			for child in gate.get_children():
				save_connecting_line_nodes(child, gate, save_node)
		
		save_scene.pack(save_node)
		ResourceSaver.save("res://saves/"+new_scene+".tscn", save_scene)
		
		#now that the scene is saved, reload the gates back into the scene
		for gate in saved_gates:
			#remove from save node, add back to root node
			for child in gate.get_children():
				if "connecting_line" in child.name:
					gate.remove_child(child)
			save_node.remove_child(gate)
			get_tree().get_root().add_child(gate)
			
		#save_file_dict(saved_gates)
			
	else:
		print("Error: Couldn't save empty scene")

func save_connecting_line_nodes(node, gate, save_node):
	"""
	if node.name == "connecting_line":
		
		#print(node.get_parent())
		#node.get_parent().remove_child(node)
		
		#remove_child(node)
		var duplicate_line = node.duplicate()
		#print(duplicate_line.get_parent().global_position - gate.global_position)
		print(duplicate_line.get_node("../"))
		print(gate.global_position)
		#print(duplicate_line.get_parent().global_position)
		print(duplicate_line.get_points()[0])
		#duplicate_line[0] = Vector2.ZERO
		gate.add_child(duplicate_line)
		duplicate_line.set_owner(save_node)
		#print(node)
		#print(node.get_parent())
		#gate_to_save_to
	"""
	if node.is_in_group("line_node"):
		for child in node.get_children():
			if "connecting_line" in child.name:

				#of the gate we're working with
				var updated_position = gate.get_node(node.name).global_position
				var new_points = []
				for point in child.get_points():
					new_points.append(point + updated_position)
				
				var duplicate_line = Line2D.new()
				var i = 0
				while gate.get_node("connecting_line"+str(i)):
					i += 1

				duplicate_line.name = "connecting_line"+str(i)
				duplicate_line.set_default_color(Color.white)
				duplicate_line.add_point(new_points[0])
				duplicate_line.add_point(new_points[1])

				gate.add_child(duplicate_line)
				duplicate_line.set_owner(save_node)	
	else:
		for child in node.get_children():
			save_connecting_line_nodes(child, gate, save_node)
