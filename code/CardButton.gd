extends Node2D

var icon = "active"
export var button_action:Dictionary = {
	"name": "",
	"action": []
}

func set_action(action):
	button_action = action
	get_node("Label").text = action["name"]

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.register_mouse_handler(self, get_node("Label"))

func _mouse_enter():
	get_node("Label").set("custom_colors/font_color", Color(1, 1, 0, 1))
	
func _mouse_exit():
	get_node("Label").set("custom_colors/font_color", Color(1, 1, 1, 1))

func _clicked():
	if not "action" in button_action:
		return
	var action:Array = button_action["action"]
	var method = action[0]
	var arguments = action.slice(1, action.size())
	var caller
	if self.has_method("action_"+method):
		caller = self
	elif Globals.has_method("action_"+method):
		caller = Globals
	if arguments.size() > 0:
		caller.call("action_"+method, arguments)
	else:
		caller.call("action_"+method)
