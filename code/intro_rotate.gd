extends Node2D
var t = 0.0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	t += delta
	var amount = sin(t*0.5)
	var off_amount = cos(t*0.5)
	print(amount)
	rotation_degrees = lerp_angle(0, 35, amount)
	position.x = lerp(32-2, 32+2, amount)
	position.y = lerp(32-2, 32+2, off_amount)
