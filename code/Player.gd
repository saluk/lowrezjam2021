extends Node2D

export var jiggle_speed = 0.07
export var rot_speed_rest = 0.3
export var rot_speed_walk = 0.5
var icon = "active"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.register_mouse_handler(self, get_node("Area2D"))
	
func _mouse_enter():
	get_node("/root/Node2D/Interface/Control/PointLabel").text = ">Status<"
	
func _mouse_exit():
	get_node("/root/Node2D/Interface/Control/PointLabel").text = ""


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_position()
	animate()
	
func update_position():
	var gp = Globals.get_player_pos()
	if gp:
		position = gp
		visible = true
	else:
		visible = false
	
func animate():
	var rot_speed = rot_speed_rest
	if Globals.walk_path:
		get_node("Node2D").position.y = int(float(Engine.get_frames_drawn()) * jiggle_speed) % 2 - 2
		rot_speed = rot_speed_walk
	rotation_degrees = int(float(Engine.get_frames_drawn()) * rot_speed) % 25
	if rotation_degrees > 25/2:
		rotation_degrees = 25/2 - rotation_degrees
	if Globals.walk_path:
		get_node("Node2D").position.y = int(float(Engine.get_frames_drawn()) * jiggle_speed) % 2 - 2
