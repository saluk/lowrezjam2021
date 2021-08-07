extends Sprite

var icon = "active"
export var button_action = "walk"

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.register_mouse_handler(self, get_node("Area2D"))

func _mouse_enter():
	material.blend_mode = BLEND_MODE_PREMULT_ALPHA
	if has_node("/root/Node2D/Interface/Control/PointLabel"):
		get_node("/root/Node2D/Interface/Control/PointLabel").text = button_action
	
func _mouse_exit():
	material.blend_mode = BLEND_MODE_MIX
	if has_node("/root/Node2D/Interface/Control/PointLabel"):
		get_node("/root/Node2D/Interface/Control/PointLabel").text = ""

func _process(delta):
	Globals.safe_call(self, button_action+"_visible")
	Globals.safe_call(self, button_action+"_position")
	#visible = true
	
func walk_visible():
	if Globals.can_walk():
		visible = true
	else:
		visible = false
	if Globals.walk_path:
		visible = false
		
func travel_method():
	if Globals.destination and Globals.destination == Globals.current_point:
		return "enter"
	return "walk"

func enter_visible():
	if travel_method() == "enter":
		visible = true
	else:
		visible = false

func walk_position():
	point_position(Globals.destination)
	
func enter_position():
	point_position(Globals.destination)
	
func point_position(point):
	if visible and point:
		var dir = Vector2(-8, -2)
		if travel_method() != "enter":
			dir = (Globals.destination.position - Globals.current_point.position).normalized() * 8
		position = point.global_position + dir

func _clicked():
	Globals.call("action_" + button_action)
