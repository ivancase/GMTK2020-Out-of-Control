extends Node2D

export (int) var WIN_AMOUNT = 0
export (int) var PAR_AMOUNT = 0
export (String) var NEXT_LEVEL = ""

func open_exit():
	print("exit open")
	get_node("power").set_text("exit open")
	get_node("exit").add_to_group("Exit")
	
func win():
	print("win")
	get_tree().change_scene("res://scenes/" + NEXT_LEVEL + ".tscn")
	
func get_win_amt():
	return WIN_AMOUNT
	
func get_par_amt():
	return PAR_AMOUNT
