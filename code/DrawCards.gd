extends Node2D

func _ready():
	if Globals.current_deck.size() == 0:
		Globals.change_scene("scenes/Map.tscn")
		Globals.alert("No more cards to draw")
	else:
		var cardindex = Globals.current_deck.pop_front()
		var card = Globals.card_templates[cardindex]
		Globals.current_card = card
		Globals.change_scene("scenes/Card.tscn")

func _process(delta):
	pass
