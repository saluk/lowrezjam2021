extends Node

var mouse_over
var icon_count = 0
var over_list = []

var handlers = []

var mouse_clicked = false

func _input(ev):
	if ev is InputEventMouseButton:
		if ev.pressed:
			if over_list and over_list[-1].has_method("_clicked"):
				over_list[-1]._clicked()

func register_mouse_handler(ob, hit):
	handlers.append(load("code/core/mouse_handler.gd").new(ob, hit))

func set_mouse_over(over):
	mouse_over = over
	if over in over_list:
		return
	over_list.append(over)
	if over.has_method("_mouse_enter"):
		print("call mouse enter")
		over._mouse_enter()
	get_node("/root/Node2D/Interface/Control/MouseCursor").set_cursor(over.icon)
	
func clear_mouse_over(over):
	mouse_over = null
	if not over in over_list:
		return
	if over.has_method("_mouse_exit"):
		over._mouse_exit()
	over_list.erase(over)
	if over_list:
		get_node("/root/Node2D/Interface/Control/MouseCursor").set_cursor(over_list[-1].icon)
	else:
		get_node("/root/Node2D/Interface/Control/MouseCursor").set_cursor("normal")
