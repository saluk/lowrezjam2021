extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var count = Globals.dice_commited
	for i in 6:
		if i < count:
			get_node("DiceToken" + str(i+1)).visible = true
		else:
			get_node("DiceToken" + str(i+1)).visible = false
