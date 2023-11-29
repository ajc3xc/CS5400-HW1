extends Node2D

var game_mode_ui = false

func set_visibility():
	if int(global.professor_mode) ^ int(game_mode_ui):
		visible = true
	else:
		visible = false
