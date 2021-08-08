extends Label
var info_box
var icon = "active"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _mouse_enter():
	set("custom_colors/font_color", Color(1, 1, 0, 1))
	info_box.show = true
	info_box.get_node("Label").text = "Active stat dice left"
	
func _mouse_exit():
	set("custom_colors/font_color", Color(1, 1, 1, 1))
	info_box.show = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.register_mouse_handler(self, self)
	info_box = get_node("/root/Node2D/Interface/Control/InfoBox")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var stat = Globals.stats[Globals.stat_checked]
	var dp = Globals.dice_commited - 1
	text = str(stat[0]-dp) + "/" + str(stat[1])
