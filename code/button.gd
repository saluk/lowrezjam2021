extends RichTextLabel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var original_text
var over = false
var click = false
var icon = "active"

func new_state():
	var shadow = get("custom_colors/font_color_shadow")
	var temp_text = original_text
	if click:
		temp_text = "[color=yellow]" + temp_text + "[/color]"
	elif over:
		#temp_text = "[tornado radius=2 freq=4]" + temp_text + "[/tornado]"
		if not shadow:
			set("custom_colors/font_color_shadow", Color(0, 0, 0, 1))
	if not over and shadow != null:
		set("custom_colors/font_color_shadow", null)
	if bbcode_text != temp_text:
		bbcode_text = temp_text

func _mouse_enter():
	#get_node("../../MouseCursor").set_cursor("active")
	over = true
	new_state()

func _mouse_exit():
	#get_node("../../MouseCursor").set_cursor("normal")
	over = false
	new_state()
	
func _button_mouse_click():
	if not click:
		click = true
	new_state()
	
func _button_mouse_release():
	click = false
	new_state()

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.register_mouse_handler(self, self)
	original_text = bbcode_text
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if over and Input.is_mouse_button_pressed(1):
		_button_mouse_click()
	if not Input.is_mouse_button_pressed(1):
		_button_mouse_release()
