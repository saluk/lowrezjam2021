extends Reference
class_name MouseHandler

var node

func _init(node, hit):
	self.node = node
	hit.connect("mouse_entered", self, "on_mouse_enter")
	hit.connect("mouse_exited", self, "on_mouse_exit")
	
func on_mouse_enter():
	Globals.set_mouse_over(node)

func on_mouse_exit():
	Globals.clear_mouse_over(node)
