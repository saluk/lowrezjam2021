extends Node2D

var show = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if show and modulate.a < 1:
		visible = true
		modulate.a += 0.1
	if not show:
		if modulate.a > 0:
			modulate.a -= 0.1
		else:
			visible = false
