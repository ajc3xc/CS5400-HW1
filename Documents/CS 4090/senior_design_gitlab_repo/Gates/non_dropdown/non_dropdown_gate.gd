extends "res://Gates/gate.gd"

#store in and out child nodes
#necessary for when changing their connected lines, if they are moving
onready var in_node = get_node("in")
onready var out_node = get_node("out")

onready var label = get_node("Label")
var label_text = "None"

#set visibility of gates
#changed in inherited classes
var show_in_node = false
var show_out_node = false
func setup_gate():
	pass
	
# Called when the node enters the scene tree for the first time.
func _ready():
	#get list of child line nodes
	setup_gate()
	disable_gate_nodes_connecting()
	var label = get_node("Label")
	
	label.text = label_text
	if show_in_node:
		get_node("in").show()
	if show_out_node:
		get_node("out").show()
	create_visible_nodes_list()
