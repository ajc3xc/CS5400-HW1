extends "res://Gates/gate.gd"

onready var drop_down_menu = $OptionButton

var selectedType = "None"
var isCorrect = false

var NONE = preload("res://Assets/black_square.png")
var OR = preload("res://Assets/OR.png")
var AND = preload("res://Assets/AND.png")
var XOR = preload("res://Assets/XOR.png")
var NOT = preload("res://Assets/NOT.png")
var NAND = preload("res://Assets/NAND.png")
var NOR = preload("res://Assets/NOR.png")
var XNOR = preload("res://Assets/XNOR.png")

#used in professor mode only
onready var bullet_sprite = get_node("Sprite") #show type of node selected

#variables for enabling / disabling nodes connected to this
var in_nodes = 0
var out_nodes = 0

var has_output = false

func _ready():
	set_visibility()
	set_sprite() #sets which sprite to be used in professor mode
	add_items()
	disable_gate_nodes_connecting()
	set_nodes_to_enable()
	enable_nodes()
	create_visible_nodes_list()


func set_visibility():
	#print(global.professor_mode)
	if global.professor_mode:
		gateColor.show()
		bullet_sprite.show()
	else:
		gateColor.hide()
		bullet_sprite.hide()

#used in inherited nodes
func set_sprite():
	bullet_sprite.set_texture(NONE)

func add_items():
	drop_down_menu.add_icon_item(NONE, "    ", 0)
	drop_down_menu.add_icon_item(OR, "    ", 1)
	drop_down_menu.add_icon_item(AND, "    ", 2)
	drop_down_menu.add_icon_item(XOR, "    ", 3)
	drop_down_menu.add_icon_item(NOT, "    ", 4)
	drop_down_menu.add_icon_item(NAND, "    ", 5)
	drop_down_menu.add_icon_item(NOR, "    ", 6)
	drop_down_menu.add_icon_item(XNOR, "    ", 7)

func set_nodes_to_enable():
	pass
	
func enable_nodes():
	if in_nodes == 1:
		get_node("mid_in_node").show()
	elif in_nodes == 2:
		get_node("up_in_node").show()
		get_node("low_in_node").show()
	
	if out_nodes==1:
		get_node("out_node").show()
	
	
func _on_OptionButton_item_selected(index):
	#current selected item
	var current_selected = index
	
	if current_selected == 0:
		selectedType = "None"
	elif current_selected == 1:
		selectedType = "OR"
	elif current_selected == 2:
		selectedType = "AND"
	elif current_selected == 3:
		selectedType = "XOR"
	elif current_selected == 4:
		selectedType = "NOT"
	elif current_selected == 5:
		selectedType = "NAND"
	elif current_selected == 6:
		selectedType = "NOR"
	elif current_selected == 6:
		selectedType = "XNOR"
	_check_if_type_correct()
		


#used in inhereited nodes
func _check_if_type_correct():
	pass
