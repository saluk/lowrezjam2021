extends Node2D

var icon = "active"
export var button_action = "walk"
export var node_text_path = "/root/Node2D/Interface/Control/PointLabel"
export var hover_description = ""
export var use_info_box = false
export var disabled_text = "Too Far To Walk"

var disabled = false
var mouse_over = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.register_mouse_handler(self, get_node("Control"))
func queue_free():
	Globals.clear_mouse_over(self)
	.queue_free()
	
func set_icon(icon):
	$Foreground.texture = ResourceLoader.load("art/gear/"+icon+".png")
	
func get_text():
	if disabled and disabled_text:
		return disabled_text
	if hover_description:
		return hover_description
	return button_action

func _mouse_enter():
	$Background.frame = 1
	if has_node(node_text_path):
		get_node(node_text_path).text = get_text()
		get_node(node_text_path).visible = true
		if use_info_box:
			get_tree().get_nodes_in_group("InfoBox")[0].show = true
	
func _mouse_exit():
	$Background.frame = 0
	if has_node(node_text_path):
		get_node(node_text_path).text = ""
		get_node(node_text_path).visible = false
		if use_info_box:
			get_tree().get_nodes_in_group("InfoBox")[0].show = false

func _process(delta):
	var last_visible = visible
	Globals.safe_call(self, button_action+"_visible")
	if not visible and last_visible and $Background.frame == 1:
		_mouse_exit()
	$Control.mouse_filter = {
		true: $Control.MOUSE_FILTER_STOP,
		false: $Control.MOUSE_FILTER_IGNORE
	}[visible]
	Globals.safe_call(self, button_action+"_position")
	Globals.safe_call(self, button_action+"_disabled")
	if disabled:
		$DisabledOverlay.visible = true
	else:
		$DisabledOverlay.visible = false
	
func walk_visible():
	if Globals.destination and not Globals.walk_path and travel_method() == "walk":
		visible = true
	else:
		visible = false
	if Globals.map_mode != "explore":
		visible = false
		
func walk_disabled():
	if not Globals.can_walk():
		disabled = true
	else:
		disabled = false
		
func add_dice_visible():
	visible = Globals.rolling_dice.size() == 0
func remove_dice_visible():
	visible = Globals.rolling_dice.size() == 0
func roll_dice_visible():
	visible = Globals.rolling_dice.size() == 0
		
func travel_method():
	if Globals.destination:
		if Globals.destination == Globals.current_point:
			return "enter"
		return "walk"
	return ""

func enter_visible():
	if travel_method() == "enter":
		visible = true
	else:
		visible = false
	if Globals.map_mode != "explore":
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
	if disabled:
		return
	if Globals.has_method("action_" + button_action):
		#Globals.clear_mouse_over(self)
		Globals.call("action_" + button_action)
