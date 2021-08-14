extends Sprite

var progress = 0

func _ready():
	visible = false
	draw()

func draw():
	visible = true

func _process(delta):
	if not visible:
		return
	scale.x = min(progress * 1.0, 0.75)
	scale.y = min(progress * 1.0, 0.75)
	progress += delta

	if progress > 0.75:
		Globals.change_scene("scenes/Card.tscn")
