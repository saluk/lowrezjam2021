extends Node2D

var icon = "active"
export var theme = "card"

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
	
func queue_free():
	Globals.clear_mouse_over(self)
	.queue_free()

func _mouse_enter():
	get_node("Label").set("custom_colors/font_color", Color(1, 1, 0, 1))
	
func _mouse_exit():
	get_node("Label").set("custom_colors/font_color", Color(1, 1, 1, 1))

func perform_card_action():
	Globals.last_action_succeeded = true
	if not "action" in button_action:
		return
	var action:Array = button_action["action"]
	if not action:
		return
	var method = action[0]
	var arguments = action.slice(1, action.size())
	
	var action_ob = Action.new(method, arguments, theme, "DrawCards")
	return Globals.call_action(action_ob)

func _clicked():
	var succeed = perform_card_action()
	if Globals.last_action_succeeded == true:
		Globals.current_card = null
