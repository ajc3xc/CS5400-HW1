extends Node2D

#store path of gateColor child node, and size of bounding box
onready var gateColor = get_node("gateColor")
onready var gateSize = gateColor.get_size()

onready var visible_line_nodes

#variables for dragging around node
var draggable: bool = false
var original_invalid_color: Color

var test_var

#variables for bounding box (make sure gates can't be dragged off screen)
var reset_position: Vector2
var in_bounds: bool = false

#variable for trash bin button (delete node if it is dragged to trash bin)
var over_trash_bin: bool = false
var trash_bin_color: ColorRect #remember the button you just hovered over

#done at start of program
#by only looping through nodes that are 
func create_visible_nodes_list():
	visible_line_nodes = []
	for child in get_children():
				if child.is_in_group("line_node") and child.visible:
					visible_line_nodes.append(child)
					

#prevent nodes in the same gate from connecting
func disable_gate_nodes_connecting():
	var child_line_nodes = []
	
	for child in get_children():
		if child.is_in_group("line_node"):
			child_line_nodes.append(child)
	
	#set their list of gate nodes
	for child in get_children():
		if child.is_in_group("line_node"):
			child.gate_nodes = child_line_nodes

#automatically changes the color if gate entered / exited
#this is only called if a line isn't actively being drawn
func _on_gateColor_mouse_entered():
	#check if color was changed
	if not global.is_dragging and not global.node_selected and global.professor_mode:
		#print("area entered")
		global.node_selected = true
		if not Input.is_action_pressed("left_click"):
			gateColor.color = Color.darkgray
			print("enabling dragging")
			draggable = true
		else:
			#visually show that this node can't be selected
			#save original circle color
			gateColor.color = Color.red

#
func _on_gateColor_mouse_exited():
	if not global.is_dragging:
		gateColor.color = Color.black
		global.node_selected = false
		draggable = false
		
func _physics_process(delta):
	if draggable:
		if Input.is_action_just_pressed("left_click"):
			get_tree().call_group("gates", "remove_old_connections")
			global.is_dragging = true
		elif Input.is_action_pressed("left_click"):
			#move center of object to mouse position
			var pos_delta = get_global_mouse_position() - gateSize / 2 - global_position
			global_position = get_global_mouse_position() - gateSize / 2
			for line_node in visible_line_nodes:
					line_node.adjust_connections_when_node_moved()
		elif Input.is_action_just_released("left_click"):
			global.is_dragging = false
			if over_trash_bin:
				remove_gate()
			if not in_bounds:
				#remove gate from list if it never was placed in bounding box
				if not reset_position:
					remove_gate()
				else:
					global_position = reset_position
					in_bounds = true
					adjust_connected_lines()

#adjust lines connected to gate
func adjust_connected_lines():
	for node in visible_line_nodes:
		node.adjust_connections_when_node_moved()

#undraw all lines connected to gate, then remove
func remove_gate():
	if trash_bin_color:
		trash_bin_color.color = Color.orange
	#I'm assuming whoever uses this code
	#isn't foolish enough to have invisible line nodes be connected to other line nodes
	for node in visible_line_nodes:
		for connected_node in node.connected_nodes.keys():
			node.erase_connection(connected_node)
	
	#delete this gate once finished disconnecting
	queue_free()

func _on_Area2D_body_entered(body):
	if body.is_in_group("bounding_box"):
		in_bounds = true
	#delete node if it is hovered over the trash bin
	elif body.is_in_group("trash_bin"):
		over_trash_bin = true
		trash_bin_color = body.get_node("ColorRect")
		#print(Color.orange)
		trash_bin_color.color = Color.darkgray

#don't mess with the boundary box, and these calculations should be fine
func _on_Area2D_body_exited(body):
	if body.is_in_group("bounding_box"):
		in_bounds = false
		#this is a cheap fix. It works, but it isn't great
		#It moves it to the center of the collision box
		#ensures that gates can never leave collision box
		reset_position = body.get_node("CollisionBox").global_position - gateSize / 2
	elif body.is_in_group("trash_bin"):
		over_trash_bin = false
		trash_bin_color.color = Color.orange
		trash_bin_color = null

func remove_old_connections():
	for child in get_children():
		if "connecting_line" in child.name:
			remove_child(child)
