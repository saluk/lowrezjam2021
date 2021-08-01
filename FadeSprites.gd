extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var fade_speed = 0.005
var animation_started = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if animation_started and modulate.a > 0:
		modulate.a -= fade_speed


func _on_TextScroll_scroll_finished():
	animation_started = true
