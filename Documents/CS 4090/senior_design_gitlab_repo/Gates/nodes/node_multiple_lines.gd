tool
extends Node2D

#variables for circle
var circle_radius = 20
var circle_color = Color.black
var original_invalid_color #used when hovering over a gate to turn it red if you're dragging the mouse while entering
var circle_position = Vector2.ZERO #where circle originates from

#variables for line drawn
var line_end = Vector2.ZERO #where the line ends
var line_start = Vector2.ZERO #where the line starts
var hovered_over = false #stores whether cursor is hovering over line node
var is_connected = false
var last_connected_node

var example_line
var connected_nodes = {} #stores dictionary of dictionaries of connected nodes

#load line from memory
onready var line = get_node("line")

#which nodes are part of the same gate
#so they can't be connected
var gate_nodes = []

var offset: Vector2

var draggable = false

# Called when the node enters the scene tree for the first time.
func _ready():
	#initialize first two points
	line.add_point(Vector2.ZERO)
	line.add_point(Vector2.ZERO)
	update()

#drawing is very problematic, so I'm clobbering together a quick fix
func _draw():
	for output_line in connected_nodes.values():
		output_line["line"].clear_points()
		output_line["line"].add_point(output_line["start"])
		output_line["line"].add_point(output_line["end"])
	line.clear_points()
	line.add_point(line_start)
	line.add_point(line_end)
	draw_circle(circle_position, circle_radius, circle_color)
		

#change circle color, reset circle position (just in case)
func change_circle_color(new_color: Color):
	circle_position = Vector2.ZERO
	circle_color = new_color
	update()

#change where line starts from
#this is when finishing drawing a line
#this is not good code, but I don't care enough
func change_line_start(new_line_start: Vector2):
	line_start = new_line_start
	update()

#draw connecting line from circle
func draw_connecting_line(mouse_position: Vector2):
	line_end = mouse_position
	update()

#automatically changes the color if circle entered / exited
#this is only called if a line isn't actively being drawn
func _on_Area2D_mouse_entered():
	hovered_over = true
	#check if color was changed
	if not global.is_dragging and not global.node_selected and global.professor_mode:
		#print("area entered")
		global.node_selected = true
		if not Input.is_action_pressed("left_click"):
			change_circle_color(Color.white)
			print("enabling dragging")
			draggable = true
		else:
			#visually show that this node can't be selected
			#save original circle color
			original_invalid_color = circle_color
			change_circle_color(Color.darkred)
	

#reset variable and colors
func reset_circle():
	draggable = false
	change_circle_color(Color.black)

func _on_Area2D_mouse_exited():
	hovered_over = false
	if original_invalid_color:
		circle_color = original_invalid_color
		original_invalid_color = null
		change_circle_color(circle_color)
	if not global.is_dragging:
		global.node_selected = false
		draggable = false
		if not is_connected:
			reset_circle()

#adjusts the lines when the node itself is moved
func adjust_connections_when_node_moved():
	#calcula
	var offset_in_circle
	var offset_inverted
	var offset_in_circle_inverted
	for member in connected_nodes:
		#change drawn line for this node
		offset = member.global_position - global_position
		offset_in_circle = offset.normalized() * circle_radius
		offset = offset - offset_in_circle
		connected_nodes[member]["end"] = offset
		connected_nodes[member]["start"] = offset_in_circle
		member.connected_nodes[self]["end"] = Vector2.ZERO
		member.connected_nodes[self]["start"] = Vector2.ZERO
		member.update()
	update()
	
	

#sets is_connected to true or false based on whether there are any connected nodes
func set_is_connected():
	if connected_nodes.size() <= 0:
		is_connected = false
		reset_circle()
	else:
		is_connected = true

#removes line and wipes dictionary entry
func erase_connection(connected_node_to_remove):
	#reset lines in both to 0
	connected_node_to_remove.change_line_start(circle_position)
	connected_node_to_remove.draw_connecting_line(circle_position)
	change_line_start(circle_position)
	draw_connecting_line(circle_position)
	
	#delete respective lines
	remove_child(connected_nodes[connected_node_to_remove]["line"])
	connected_node_to_remove.remove_child(connected_node_to_remove.connected_nodes[self]["line"])
	
	#delete entries in dictionaries
	connected_node_to_remove.connected_nodes.erase(self)
	connected_nodes.erase(connected_node_to_remove)
	
	#change is_connected state if dictionary is empty
	set_is_connected()
	connected_node_to_remove.set_is_connected()

func _physics_process(delta):
	if draggable:
		if Input.is_action_just_pressed("left_click"):
			print("pressed start")
			change_line_start(circle_position)
			global.is_dragging = true
			get_tree().call_group("gates", "remove_old_connections")
		if Input.is_action_pressed("left_click"):
			offset = get_global_mouse_position() - global_position
			draw_connecting_line(offset)
			#variable storing whether a member is already connected
			#ensures only one member can be connected to
			var no_connecting_members = true
			for member in get_tree().get_nodes_in_group("line_node"):
				if member != self:
					if member.hovered_over:
						#if so, check if it is currently being hovered over
						if no_connecting_members and not gate_nodes.has(member):
							last_connected_node = member
							no_connecting_members = false
							member.change_circle_color(Color.white)
					#otherwise, reset the color
					elif member.connected_nodes.size() > 0:
						member.change_circle_color(Color.white)
					else:
						member.change_circle_color(Color.black)
			if no_connecting_members:
				last_connected_node = null
			#print(connected_node)
			
		if Input.is_action_just_released("left_click"):
			print("released")
			global.is_dragging = false
			if last_connected_node:
				#turn off draggable and hovered_over for these nodes
				draggable = false
				hovered_over = false
				last_connected_node.draggable = false
				global.node_selected = false
				last_connected_node.hovered_over = false
				global.is_dragging = false
				#ensure neither node has been connected to the other before
				if not connected_nodes.has(last_connected_node):
					if not last_connected_node.connected_nodes.has(self):
						
						#add new line for this node
						var new_line = Line2D.new()
						new_line.name = "connecting_line"
						new_line.set_default_color(Color.white)
						add_child(new_line)
						
						#calculate start and end for line
						offset = last_connected_node.global_position - global_position
						var offset_in_circle = offset.normalized() * circle_radius
				
						offset = offset - offset_in_circle
						connected_nodes[last_connected_node] = {"line": new_line,
														"start": offset_in_circle,
														"end": offset}
														
						#add new line for connected node
						#this is necessary so both know they reference each other
						var connected_new_line = Line2D.new()
						
						connected_new_line.name = "connecting_line"
						connected_new_line.set_default_color(Color.white)
						last_connected_node.add_child(connected_new_line)
						
						
						#draw an empty line for the connected node
						last_connected_node.change_circle_color(Color.white)
						last_connected_node.connected_nodes[self] = {"line": connected_new_line,
														"start": Vector2.ZERO,
														"end": Vector2.ZERO}
						
						draw_connecting_line(circle_position)
						
						#set is_connected to true for both
						is_connected = true
						last_connected_node.is_connected = true
														
					#other node was connected to this one
					else:
						erase_connection(last_connected_node)
				#this node was connected to it
				else:
					erase_connection(last_connected_node)
						
			#did not connect to a new node	
			else:
				if not is_connected:
					reset_circle()
				draw_connecting_line(circle_position)
				draggable = false
				global.node_selected = false
				global.is_dragging = false
