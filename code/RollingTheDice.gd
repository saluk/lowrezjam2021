extends Node2D

var have_dice = false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func start_roll():
	get_node("/root/Node2D/Interface/Control/DicePool").queue_free()
	var x = 10
	var y = 20
	var rolling_die_node = ResourceLoader.load("scenes/RollingDice.tscn")
	for die in Globals.rolling_dice:
		var rolling_die = rolling_die_node.instance()
		rolling_die.position.x = x
		rolling_die.position.y = y
		x += rand_range(10,15)
		if x> 60:
			x = 10
			y += rand_range(15,20)
		add_child(rolling_die)
		
	have_dice = true
	
func stop_roll():
	var box = "/root/Node2D/Interface/Control/ResultBox"
	var label = box + "/Label"
	var sum = sum_die()
	if sum >= Globals.target_number:
		get_node(label).text = str(sum_die()) + ". Pass! You find 1 gold."
	else:
		get_node(label).text = str(sum_die()) + ". Fail! You lose 2 hp."
	get_node(box).show = true
	
func sum_die():
	var sum = 0
	for die in Globals.rolling_dice:
		sum += die[0]
	return int(sum)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Globals.rolling_dice and not have_dice:
		start_roll()
	if not have_dice:
		return

	var waiting = Globals.rolling_dice.size()
	for i in Globals.rolling_dice.size():
		var rolling_die = get_child(i)
		var die = Globals.rolling_dice[i]
		die[1] = die[1] - delta
		if die[1] < 0:
			die[1] = 0
			rolling_die.rolling = false
			rolling_die.set_number(die[0])
			waiting -= 1
	if waiting <= 0:
		stop_roll()
