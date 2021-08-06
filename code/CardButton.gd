extends Node2D

var icon = "active"
export var button_action:Dictionary = {
	"name": "",
	"actions": []
}

func set_action(action):
	button_action = action
	get_node("Label").text = action["name"]

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.register_mouse_handler(self, get_node("Label"))

func _mouse_enter():
	print("mouse enter")
	get_node("Label").set("custom_colors/font_color", Color(1, 1, 0, 1))
	
func _mouse_exit():
	get_node("Label").set("custom_colors/font_color", Color(1, 1, 1, 1))

func _clicked():
	for action in button_action["actions"]:
		if self.has_method("action_"+action):
			self.call("action_"+action)
		elif Globals.has_method("action_"+action):
			Globals.call("action_"+action)
