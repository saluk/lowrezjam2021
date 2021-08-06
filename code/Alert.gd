extends Label
var max_speed = 80
var min_speed = 10

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var speed = 80
	rect_position.x -= speed*delta
	if rect_position.x < -32:
		get_node("../../").queue_free()
