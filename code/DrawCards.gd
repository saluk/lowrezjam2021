extends Node2D

func _ready():
	if Globals._hp_below_zero():
		return
	if not Globals.current_deck:
		return
	if Globals.current_deck.size() == 0:
		Globals.change_scene("scenes/Map.tscn")
		Globals.alert("No more cards to draw. Resting...")
		Globals.rest()
	else:
		var cardindex = Globals.current_deck.pop_front()
		var card = Globals.get_card_template(cardindex)
		Globals.current_card = card
		Globals.change_scene("scenes/Card.tscn")

func _process(delta):
	pass
