extends Label

var last_hp = null
var shake = 0.0
var bounce = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not last_hp:
		last_hp = Globals.gp
	if Globals.gp < last_hp:
		shake = 0.5
	elif Globals.gp > last_hp:
		bounce = 0.5
		rect_position.y = -4
	if bounce > 0:
		if rect_position.y < 0:
			rect_position.y += 4 * delta
		bounce -= delta
	else:
		rect_position = Vector2(0,0)
	if shake > 0:
		rect_position.x = rand_range(-2.0, 2.0)
		rect_position.y = rand_range(-2.0, 2.0)
		shake -= delta
	else:
		rect_position = Vector2(0,0)
		
	last_hp = Globals.gp
	text = "G:"+str(last_hp)
