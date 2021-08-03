extends Node2D

signal mouse_cursor_moved

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _input(ev):
	if ev is InputEventMouseMotion:
		var new_pos = Vector2(int(ev.position.x), int(ev.position.y))
		if new_pos != position:
			var relative = new_pos - position
			position = new_pos
			emit_signal("mouse_cursor_moved", position, relative)

func set_cursor(art):
	$Sprite.texture = ResourceLoader.load("res://art/" + art + "_cursor.png")

func _on_ScrollMap_override_mouse(mouse_icon = "default"):
	set_cursor(mouse_icon)
	
