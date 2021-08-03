extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var icon = "active"

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.register_mouse_handler(self, self)
