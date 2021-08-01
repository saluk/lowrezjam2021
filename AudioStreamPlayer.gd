extends AudioStreamPlayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var d = Directory.new()
	if d.open("res://music") == OK:
		d.list_dir_begin()
		var music_files = []
		var file_name = d.get_next()
		while file_name != "":
			if file_name.ends_with(".mp3"):
				music_files.append(file_name)
			file_name = d.get_next()
		print(music_files)
		music_files.shuffle()
		stream = ResourceLoader.load("res://music/" + music_files[0])
		play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
