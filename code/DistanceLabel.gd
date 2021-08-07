extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var dist = Globals.get_distance()
	if dist <= 0 or Globals.walk_path:
		visible = false
		return
	text = str(dist) + "km"
	visible = true
