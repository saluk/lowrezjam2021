extends Node2D

var mh1
var icon = "drag"

var click = false
var true_offset = Vector2(0,0)

func drag_start():
	click = true
	
func drag_end():
	click = false

func _ready():
	Globals.register_mouse_handler(self, get_node("Area2D"))

func _input(ev):
	if ev is InputEventMouseButton:
		if ev.pressed:
			if not click:
				drag_start()
		else:
			drag_end()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_MouseCursor_mouse_cursor_moved(_cursor_position, relative):
	if click:
		position += relative
