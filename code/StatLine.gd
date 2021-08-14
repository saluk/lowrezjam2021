extends Label

var icon = "active"
var stat
var info_box

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _mouse_enter():
	set("custom_colors/font_color", Color(1, 1, 0, 1))
	info_box.show = true
	info_box.get_node("Label").text = Globals.stat_descriptions[stat]
	
func _mouse_exit():
	set("custom_colors/font_color", Color(1, 1, 1, 1))
	info_box.show = false

# Called when the node enters the scene tree for the first time.
func _ready():
	info_box = get_node("/root/StatsMenu/Interface/Control/InfoBox")
	Globals.register_mouse_handler(self, self)

func set_stat(inc_stat):
	stat = inc_stat
	text = stat
	var value = Globals.stats[stat]
	get_node("Label").text = ": " + str(value[0]) + "/" + str(value[1])

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
