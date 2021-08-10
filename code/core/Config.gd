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
	settings = parse_json(file.get_as_text())
	return true

func get(key):
	return settings[key]
