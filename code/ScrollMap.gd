extends Node2D

var mh1
var icon = "drag"

var have_scrolled = false
var click = false
var true_offset = Vector2(0,0)

func drag_start():
	click = true
	
func drag_end():
	click = false

func _ready():
	if Globals._hp_below_zero():
		return
	if Globals.won_game():
		return
	Globals.proper_scene()
	Globals.register_mouse_handler(self, get_node("/root/Node2D/Control"))
	get_node("/root/MouseCursor").connect(
		"mouse_cursor_moved",
		self,
		"_on_MouseCursor_mouse_cursor_moved"
	)

func _input(ev):
	if ev is InputEventMouseButton:
		if ev.pressed:
			if not click:
				drag_start()
		else:
			drag_end()
			
func scroll_to_player(speed):
	var player = get_node("Player")
	if player.global_position.x < 32:
		position.x += speed
	if player.global_position.x > 32:
		position.x -= speed
	if player.global_position.y < 32:
		position.y += speed
	if player.global_position.y > 32:
		position.y -= speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var player = get_node("Player")
	if not player.visible:
		return
	if have_scrolled and not Globals.walk_path:
		return
	scroll_to_player(8)

func _on_MouseCursor_mouse_cursor_moved(_cursor_position, relative):
	if click:
		have_scrolled = true
		position += relative
