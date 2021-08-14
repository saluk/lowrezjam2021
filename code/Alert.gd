extends Node2D
var fade_speed = 2
var fade_dir = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	modulate.a = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var cur_par = get_parent()
	var par = cur_par
	if get_tree().get_nodes_in_group("alertanchor"):
		par = get_tree().get_nodes_in_group("alertanchor")[0]
	if par != cur_par:
		cur_par.remove_child(self)
		par.add_child(self)

	if fade_dir > 0 and modulate.a < 1.0:
		modulate.a += fade_speed * delta
	if fade_dir < 0 and modulate.a > 0:
		modulate.a -= fade_speed * delta
	if fade_dir < 0 and modulate.a <= 0:
		Globals._alert -= 1
		queue_free()
