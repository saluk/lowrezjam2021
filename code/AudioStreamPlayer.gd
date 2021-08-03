extends AudioStreamPlayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var intro_music = [
	'aderin-pursuit',
	'alexander-nakarada-psychotic',
	'arthur-vyncke-uncertainty',
	'batchbug-flesh-and-bones',
	'fm-freemusic-regret-and-sadness',
	'pratzapp-aadhithya-ambush',
	'pyrosion-trust',
	'scott-buckley-beyond-these-walls',
	'yoitrax-dark-web',
	'yoitrax-lonely-streets'
]

# Called when the node enters the scene tree for the first time.

func _ready():
	random_song()
	play()
	
func random_song():
	randomize()
	intro_music.shuffle()
	stream = ResourceLoader.load("music/" + intro_music[0] + ".mp3")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
