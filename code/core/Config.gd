extends Reference
class_name Config

var settings:Dictionary

func _init():
	load_settings()
	
func load_settings():
	var fn = "res://data/world.json"
	var file = File.new()
	if not file.file_exists(fn):
		return false
	file.open(fn, File.READ)
	while file.get_position() < file.get_len():
		settings = parse_json(file.get_line())
	return true

func get(key):
	return settings[key]
