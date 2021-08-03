extends Node2D

export var jiggle_speed = 0.07
export var rot_speed = 0.5

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation_degrees = int(float(Engine.get_frames_drawn()) * rot_speed) % 25
	if rotation_degrees > 25/2:
		rotation_degrees = 25/2 - rotation_degrees
	get_node("Node2D").position.y = int(float(Engine.get_frames_drawn()) * jiggle_speed) % 2 - 2
