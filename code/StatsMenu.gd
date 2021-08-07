extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var statline_node = ResourceLoader.load("scenes/StatLine.tscn")
	var x = 1
	var y = 16
	for stat in Globals.stats:
		var statline = statline_node.instance()
		statline.set_stat(stat)
		statline.rect_position.x = x
		statline.rect_position.y = y
		y += 12
		get_node("Interface/Control/StatLines").add_child(statline)
