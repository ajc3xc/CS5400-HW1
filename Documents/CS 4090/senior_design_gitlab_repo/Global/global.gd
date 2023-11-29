extends Node

#check if node or drop down menu is being dragged
var is_dragging = false
var node_selected = false

#enable / disable professor mode
var professor_mode = true setget set_professor_mode
var play_mode = false setget set_play_mode

#emit signal that professor mode was changed
signal change_professor_mode()

func set_professor_mode(val: bool):
	professor_mode = val
	emit_signal("change_professor_mode", self)
	get_tree().call_group("gates", "set_visibility")
	get_tree().call_group("UI", "set_visibility")
	
func set_play_mode(val: bool):
	play_mode = val
	get_tree().call_group("toggler", 'set_play_mode_visbility')
