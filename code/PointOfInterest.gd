extends Node2D

var icon = "active"
export var location_name = "Tree of Wealth"
var active = false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.register_mouse_handler(self, get_node("Area2D"))
	
func is_current_point():
	return Globals.current_point_location == location_name


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _mouse_enter():
	get_node("/root/Node2D/Interface/Control/PointLabel").text = location_name
	
func _mouse_exit():
	get_node("/root/Node2D/Interface/Control/PointLabel").text = ""
	
func _process(delta):
	if is_current_point():
		Globals.current_point = self
	draw_destination_line()
		
func _clicked():
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
		
func draw_destination_line():
	if not is_current_point():
		return
	update()
	
func _draw():
	if not is_current_point():
		return
	if not Globals.destination:
		return
	draw_line(
		Vector2(0, 0), 
		Globals.destination.position - position, 
		Color(0, 0, 0), 
		1.0, 
		false)
