extends Reference
class_name Config

var settings:Dictionary

func _init(path):
	load_settings(path)
	
func load_settings(path):
	var fn = "res://"+path
	var file = File.new()
	if not file.file_exists(fn):
		return false
	file.open(fn, File.READ)
	settings = parse_json(file.get_as_text())
	return true

func get(key):
	return settings[key]
