extends Node2D
var fade_speed = 2
var fade_dir = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	modulate.a = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if fade_dir > 0 and modulate.a < 1.0:
		modulate.a += fade_speed * delta
	if fade_dir < 0 and modulate.a > 0:
		modulate.a -= fade_speed * delta
	if fade_dir < 0 and modulate.a <= 0:
		queue_free()
