extends Label

var icon = "active"
var info_box

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _mouse_enter():
	set("custom_colors/font_color", Color(1, 1, 0, 1))
	info_box.show = true
	info_box.get_node("Label").text = "Roll over this\nto pass"
	
func _mouse_exit():
	set("custom_colors/font_color", Color(1, 1, 1, 1))
	info_box.show = false

# Called when the node enters the scene tree for the first time.
func _ready():
	info_box = get_node("/root/SkillCheck/Interface/Control/InfoBox")
	Globals.register_mouse_handler(self, self)
	text = "Goal: " + str(Globals.target_number)
