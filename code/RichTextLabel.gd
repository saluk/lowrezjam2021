extends RichTextLabel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var scroll_speed = 0.2
signal scroll_finished


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	margin_top -= scroll_speed
	if margin_top <= -16:
		emit_signal("scroll_finished")
