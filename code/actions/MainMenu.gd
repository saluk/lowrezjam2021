extends ActionSet
class_name MainMenu
func _init(v).(v):
	pass
	
func action_new_game():
	Globals.new_game()
	Globals.change_scene("res://scenes/Map.tscn")
	
func action_load_game():
	Globals.load_game()
	Globals.change_scene("res://scenes/Map.tscn")
	
func action_quit_game():
	Globals.get_viewport().queue_free()
