extends "res://Gates/gate.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	create_visible_nodes_list()




func _on_LineEdit_mouse_entered():
	if not global.is_dragging and global.professor_mode:
		draggable = true


func _on_LineEdit_mouse_exited():
	if not global.is_dragging and global.professor_mode:
		draggable = false
		
func set_visibility():
	if global.professor_mode:
		get_node("LineEdit").visible = true
		get_node("gateColor").color = Color("#2B2B2B")
	else:
		get_node("LineEdit").visible = false
		get_node("gateColor").color = Color("#2B2B2B")

func _on_LineEdit_text_changed(new_text):
	get_node("Label").text = new_text
