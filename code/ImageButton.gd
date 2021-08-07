extends Sprite

var icon = "active"
export var button_action = "walk"
export var node_text_path = "/root/Node2D/Interface/Control/PointLabel"
export var hover_description = ""
export var use_info_box = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.register_mouse_handler(self, get_node("Area2D"))
	
func get_text():
	if hover_description:
		return hover_description
	return button_action

func _mouse_enter():
	material.blend_mode = BLEND_MODE_PREMULT_ALPHA
	if has_node(node_text_path):
		get_node(node_text_path).text = get_text()
		if use_info_box:
			get_node("/root/Node2D/Interface/Control/InfoBox").show = true
	
func _mouse_exit():
	material.blend_mode = BLEND_MODE_MIX
	if has_node(node_text_path):
		get_node(node_text_path).text = ""
		if use_info_box:
			get_node("/root/Node2D/Interface/Control/InfoBox").show = false

func _process(delta):
	Globals.safe_call(self, button_action+"_visible")
	Globals.safe_call(self, button_action+"_position")
	
func walk_visible():
	if Globals.can_walk():
		visible = true
	else:
		visible = false
	if Globals.walk_path:
		visible = false
		
func add_dice_visible():
	visible = Globals.rolling_dice.size() == 0
func remove_dice_visible():
	visible = Globals.rolling_dice.size() == 0
func roll_dice_visible():
	visible = Globals.rolling_dice.size() == 0
		
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
