extends Node2D

var have_dice = false
var stopped = false
var x
var y
var alerted = false
var left = 15
var top = 20

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func start_roll():
	get_node("/root/SkillCheck/Interface/Control/DicePool").queue_free()
	x = left
	y = top
	for die in Globals.rolling_dice:
		start_die(die)
		
	have_dice = true
	
func stop_roll():
	stopped = true
	var box = "/root/SkillCheck/Interface/Control/ResultBox"
	var label = box + "/Label"
	var sum = sum_die()
	#TODO If you have a card that affects the outcome of a roll, it can be played here
	Globals.check_result_successful = sum >= Globals.target_number
	if Globals.check_result_successful:
		get_node(label).text = str(sum_die()) + ". Pass! " + Globals.check_win[0]
	else:
		get_node(label).text = str(sum_die()) + ". Fail! " + Globals.check_lose[0]
		Globals.card_result(Globals.check_lose)
	get_node(box).show = true
	var proc_ones = 0
	for die in Globals.rolling_dice:
		if die[0] == 1:
			proc_ones += 1
	var can_proc_ones = Globals.get_equip_recover(Globals.stat_checked)
	proc_ones = min(can_proc_ones, proc_ones)
	if proc_ones > 0:
		Globals.recover_stat(Globals.stat_checked, proc_ones)
	
func sum_die():
	var sum = 0
	for die in Globals.rolling_dice:
		sum += die[0]
	sum += Globals.get_equip_roll_bonus(Globals.stat_checked)
	if sum <= 0:
		sum = 0
	return int(sum)

func start_die(die):
	var rolling_die_node = ResourceLoader.load("scenes/RollingDice.tscn")
	var rolling_die = rolling_die_node.instance()
	rolling_die.position.x = x
	rolling_die.position.y = y + rand_range(-2,2)
	x += rand_range(10,15)
	if x> 44:
		x = left
		y += 9
	add_child(rolling_die)
	
func stop_die(die, rolling_die):
	die[1] = 0
	rolling_die.rolling = false
	rolling_die.set_number(die[0])
	if die[0] == 6:
		var new_die = Globals.add_rolling_die()
		if new_die:
			var effect = ResourceLoader.load("scenes/DieShimmer.tscn").instance()
			effect.position = rolling_die.get_node("AnimatedSprite").position
			rolling_die.add_child(effect)
			start_die(new_die)
		elif not alerted:
			alerted = true
			Globals.alert("Max dice reached")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Globals.rolling_dice and not have_dice:
		start_roll()
	if not have_dice:
		return

	var waiting = Globals.rolling_dice.size()
	var size = Globals.rolling_dice.size()
	for i in size:
		var rolling_die = get_child(i)
		var die = Globals.rolling_dice[i]
		if die[1] > 0:
			die[1] = die[1] - delta
		if die[1] <= 0:
			if rolling_die.rolling:
				stop_die(die, rolling_die)
			else:
				waiting -= 1
			
	if waiting <= 0 and not stopped:
		stop_roll()
