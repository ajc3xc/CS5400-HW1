extends "set_visibility.gd"

#paths to location of gate scenes
var LABEL = preload("res://Gates/Label/Label.tscn")
var AND = preload("res://Gates/dropdown/AND.tscn")
var OR = preload("res://Gates/dropdown/OR.tscn")
var XOR = preload("res://Gates/dropdown/XOR.tscn")
var NOT = preload("res://Gates/dropdown/NOT.tscn")
var NAND = preload("res://Gates/dropdown/NAND.tscn")
var NOR = preload("res://Gates/dropdown/NOR.tscn")
var XNOR = preload("res://Gates/dropdown/XNOR.tscn")
var ON = preload("res://Gates/non_dropdown/in_on_gate.tscn")
var OFF = preload("res://Gates/non_dropdown/in_off_gate.tscn")
var OUT = preload("res://Gates/non_dropdown/out_gate.tscn")
var CONNECT = preload("res://Gates/non_dropdown/connector_gate.tscn")

var save_node = Node2D.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_Label_button_down():
	spawn_gate(LABEL)
	

func _on_AND_button_down():
	spawn_gate(AND)


func _on_OR_button_down():
	spawn_gate(OR)


func _on_XOR_button_down():
	spawn_gate(XOR)


func _on_NOT_button_down():
	spawn_gate(NOT)


func _on_NAND_button_down():
	spawn_gate(NAND)


func _on_NOR_button_down():
	spawn_gate(NOR)


func _on_XNOR_button_down():
	spawn_gate(XNOR)


func _on_ON_button_down():
	spawn_gate(ON)


func _on_OFF_button_down():
	spawn_gate(OFF)


func _on_OUT_button_down():
	spawn_gate(OUT)


func _on_CONNECT_button_down():
	spawn_gate(CONNECT)

func spawn_gate(gateType: PackedScene):

	if global.professor_mode and not global.is_dragging:
		var gate = gateType.instance()
		var gate_centered: Vector2 = gate.get_node("gateColor").get_size() / 2
		
		var gate_start_position: Vector2 = get_global_mouse_position() - gate_centered
		gate.position = gate_start_position
		gate.draggable = true

		get_tree().get_root().add_child(gate)

