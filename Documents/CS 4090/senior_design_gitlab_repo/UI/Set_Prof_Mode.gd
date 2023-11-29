extends "set_visibility.gd"


func set_play_mode_visbility():
	if global.play_mode:
		visible = false
	else:
		visible = true

func _on_Button_pressed():
	global.professor_mode = !global.professor_mode
