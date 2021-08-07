extends Node2D

var card
var card_button_scene = ResourceLoader.load("res://scenes/CardButton.tscn")


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var card_button
	var y = 47
	var x = 8
	card = Globals.current_card
	if not card:
		return
	get_node("Interface/CardName").text = card["name"]
	if card["art"]:
		var texture_name = card["art"][rand_range(0,card["art"].size())]
		var texture = ResourceLoader.load("art/cards/"+texture_name+".png")
		get_node("Background").texture = texture
	for action in card["actions"]:
		card_button = card_button_scene.instance()
		card_button.position = Vector2(x, y)
		y += 8
		card_button.set_action(action)
		get_node("/root/Node2D/Interface/Buttons").add_child(
			card_button
		)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if position.x == 0 and position.y == 0 and rotation_degrees == 0 and scale.x == 1 and scale.y == 1:
		get_node("Interface/Control/MouseCursor").visible = true
		return
	get_node("Interface/Control/MouseCursor").visible = false
	if rotation_degrees < 0:
		rotation_degrees += 1
	if scale.x < 1:
		scale.x += 0.032
	if scale.x > 0:
		get_node("CardBack").visible = false
	if scale.x > 1: scale.x = 1
	if scale.y < 1:
		scale.y += 0.025
	if scale.y > 1: scale.y = 1
	if position.x > 0:
		position.x -= 1
	if position.y > 0:
		position.y -= 1
	position.x = int(position.x)
	position.y = int(position.y)
