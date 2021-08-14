extends Node2D

var icon = "active"
export var location_name = "Tree of Wealth"
var active = false

export var is_cp = false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.register_mouse_handler(self, get_node("Control"))
	get_node("AnimatedSprite").set_animation(Globals.config.get("points")[location_name]["type"])
	
func is_current_point():
	return Globals.current_point_location == location_name


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _mouse_enter():
	get_node("/root/Node2D/Interface/Control/PointLabel").text = location_name
	get_node("/root/Node2D/Interface/Control/PointLabel").visible = true
	
func _mouse_exit():
	get_node("/root/Node2D/Interface/Control/PointLabel").text = ""
	get_node("/root/Node2D/Interface/Control/PointLabel").visible = false
	
func _process(delta):
	if is_current_point():
		Globals.current_point = self
	update()
		
func _clicked():
	if Globals.map_mode != "explore":
		return
	if not Globals.walk_path:
		Globals.set_destination(self)
	
func activate():
	if not active:
		active = true
		get_node("AnimatedSprite").play()

func deactivate():
	if active:
		active = false
		get_node("AnimatedSprite").stop()
		get_node("AnimatedSprite").frame = 0
	
# Copied from reddit
func draw_empty_circle(circle_center:Vector2, circle_radius:Vector2, color:Color, resolution:int):
	var draw_counter = 1
	var line_origin = Vector2()
	var line_end = Vector2()
	line_origin = circle_radius + circle_center

	while draw_counter <= 360:
		line_end = circle_radius.rotated(deg2rad(draw_counter)) + circle_center
		draw_line(line_origin, line_end, color)
		draw_counter += 1 / resolution
		line_origin = line_end

	line_end = circle_radius.rotated(deg2rad(360)) + circle_center
	draw_line(line_origin, line_end, color)
	
func _draw():
	if not is_current_point():
		return
	if Globals.map_mode != "explore":
		return
	draw_empty_circle(
		Vector2(0,0), 
		Vector2(
			Globals.get_max_distance()*Globals.distance_to_travel_per_speed,
			0), 
		Color(0,1,0),
		1)
	if not Globals.destination:
		return
	var color = Color(0,0,0)
	if not Globals.can_walk():
		color = Color(1,0,0)
	draw_line(
		Vector2(0, 0), 
		Globals.destination.position - position, 
		color, 
		1.0, 
		false)
