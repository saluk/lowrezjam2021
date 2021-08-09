extends Node2D

var show = false

func _process(delta):
	#if get_node("/root/MouseCursor").position < 32:
	#	position.y = 
	if show and modulate.a < 1:
		visible = true
		modulate.a += 0.1
	if not show:
		if modulate.a > 0:
			modulate.a -= 0.1
		else:
			visible = false
