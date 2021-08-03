extends Node2D

var icon = "active"
export var location_name = "Tree of Wealth"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.register_mouse_handler(self, get_node("Area2D"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _mouse_enter():
	get_node("/root/Node2D/Interface/Control/Label").text = location_name
	
func _mouse_exit():
	get_node("/root/Node2D/Interface/Control/Label").text = "Where to?"
