extends Node

export var travel_speed = 10 # 2
export var distance_to_travel_per_speed = 5

var mouse_over
var icon_count = 0
var over_list = []

var _alert = 0
var _won = 0
var rng

var handlers = []

var config:Config
var card_templates:Array
var save_keys = ["current_point_location", "cards", "stats", "gp", "hp"]

var current_point_location = "Green Coast" # save
var cards = {} # save
var stats = {} # save
var equipment:Array = [{"name":"Boots (spd+1)", "art":[], "actions": [
		{"name":"Equip", "action":["equip"]},
		{"name":"Discard", "action":["close_card"]} 
	], "bonus":["speed",1], "icon":"boots"}] # save
var hp = 3 # save
var gp = 2 # save
var stat_descriptions = {
	"guile":"outsmart\npeople",
	"power":"win battles",
	"speed":"km to walk\nbefore rest",
	"lore":"solve puzzles"
}

var current_point = null

var mouse_clicked = false
var destination = null
var walk_path = null
var current_card = null
var current_deck = null

# stat check
var dice_commited = 1
var stat_checked = "power"
var rolling_dice = []
var target_number = 10
var check_win = []
var check_lose = []
var check_result_successful = false

var events = []
var sounds = []

func _init():
	config = Config.new("data/world.json")
	card_templates = Config.new("data/cards.json").get("card_templates")
	rng = RandomNumberGenerator.new()
	rng.randomize()
	new_game()
	
func get_card_template(index_or_name):
	if typeof(index_or_name) == TYPE_INT:
		return card_templates[index_or_name]
	if typeof(index_or_name) == TYPE_REAL:
		return card_templates[int(index_or_name)]
	for card in card_templates:
		if card["name"] == index_or_name:
			return card

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS

func get_player_pos():
	if not walk_path and current_point:
		return current_point.position + Vector2(6, 2)
	if not walk_path:
		return null
	var dir = walk_path["end"].position - walk_path["start"].position
	var prog_vec = dir.normalized() * walk_path["progress"]
	return walk_path["start"].position + prog_vec
	
func proper_scene():
	if current_deck and current_deck.size() > 0:
		change_scene("scenes/DrawCards.tscn")

func _input(ev):
	if ev is InputEventMouseButton:
		if ev.pressed:
			if over_list and over_list[-1] and over_list[-1].has_method("_clicked"):
				over_list[-1]._clicked()

func register_mouse_handler(ob, hit):
	handlers.append(load("code/core/mouse_handler.gd").new(ob, hit))

func set_mouse_over(over):
	mouse_over = over
	if over in over_list:
		return
	over_list.append(over)
	if over.has_method("_mouse_enter"):
		over._mouse_enter()
	get_node("/root/MouseCursor").set_cursor(over.icon)
	
func clear_mouse_over(over):
	mouse_over = null
	if not over in over_list:
		return
	if over.has_method("_mouse_exit"):
		over._mouse_exit()
	over_list.erase(over)
	if over_list and is_instance_valid(over_list.back()):
		print(over_list.back())
		get_node("/root/MouseCursor").set_cursor(over_list.back().icon)
	else:
		get_node("/root/MouseCursor").set_cursor("normal")

func set_destination(point):
	if self.destination:
		self.destination.deactivate()
	self.destination = point
	self.destination.activate()

func get_distance():
	if not self.destination:
		return -1
	if not self.current_point:
		return -1
	var pixels = (destination.position - current_point.position).length()
	return int(pixels/distance_to_travel_per_speed)

func get_max_distance():
	return stats["speed"][1]
# can we walk to the destination from our current point
func can_walk():
	var dist = get_distance()
	if get_distance() < 0:
		return false
	if dist > get_max_distance():
		return false
	return true

func safe_call(object, method):
	if object.has_method(method):
		object.call(method)
		
func call_action(action):
	print("Execute action:",action.method," in ",action.theme," with ",action.arguments)
	var action_class = null
	if action.theme == "card":
		action_class = CardActions.new(action)
	elif action.theme == "check":
		action_class = CheckActions.new(action)
	elif action.theme == "menu":
		action_class = MainMenu.new(action)
	if action_class and action_class.has_method("action_"+action.method):
		action_class.call("action_"+action.method)
	else:
		call("action_"+action.method, action)
		
func add_event(name, arguments):
	events.append([name, arguments])
	print(events)
		
func play_sound(sound, seek_pos):
	var stream = AudioStreamPlayer.new()
	stream.stream = ResourceLoader.load(sound)
	stream.playing = true
	stream.seek(seek_pos)
	add_child(stream)
	sounds.append(stream)
	
func card_result(result):
	print(result)
	var text = result[0]
	var sub_actions = result.slice(1,result.size())
	print(sub_actions)
	for action in sub_actions:
		call_action(Action.new(
			action[0], 
			action.slice(1, action.size()),
			"card"
		))
			
func action_add_event(arguments):
	add_event(arguments[0], arguments.slice(1,arguments.size()))
	
func draw_card(arguments):
	var card_index = arguments[0]
	current_card = get_card_template(card_index)
	print(current_card)
	change_scene("res://scenes/Card.tscn")

func won_game():
	if _won:
		return true
	if get_rune_count() >= config.get("rune_count"):
		alert("You have collected all of the runes!")
		alert("As you repeat them aloud, a portal appears.")
		alert("Your adventures have come to an end.")
		alert("...\nfor now\n...")
		add_event("change_scene", ["scenes/intro.tscn"])
		_won += 1
		return true

func get_rune_count():
	var total = 0
	for card in equipment:
		if card["name"].begins_with("Rune"):
			total += 1
	return total
	
func modify(field, amount):
	print("modifying ",field," by ",amount)
	set(field, get(field) + amount)
	if get(field) <= 0:
		set(field, 0)
			
func stat_up(stat, amount):
	stats[stat] = [stats[stat][0] + amount, stats[stat][1] + amount]
	alert(
		"You level up! " + stat + " to "+str(stats[stat][0]) + "/" +str(stats[stat][1])
	)
			
func _hp_below_zero():
	if hp <= 0:
		events.clear()
		_alert = 0
		alert("Game Over!")
		change_scene("res://scenes/intro.tscn")
		return true
		
func rest():
	for stat in stats:
		stats[stat][0] = stats[stat][1]
	hp += 2
	if hp >= stats["power"][1]:
		hp = stats["power"][1]
	
func action_walk():
	walk_path = {
		"start":current_point,
		"end":destination,
		"length":(destination.position-current_point.position).length(),
		"progress":0.0
	}
	
func action_enter():
	current_deck = load_deck_at(current_point_location)
	if current_deck:
		change_scene("res://scenes/DrawCards.tscn")
	
func action_close_card():
	change_scene("res://scenes/Map.tscn")
	save_game()
	
func action_add_dice():
	dice_commited += 1
	if dice_commited > stats[stat_checked][0] + 1:
		dice_commited = stats[stat_checked][0] + 1
	if dice_commited > 6:
		dice_commited = 6

func action_remove_dice():
	dice_commited -= 1
	if dice_commited < 1:
		dice_commited = 1
		
func action_roll_dice():
	stats[stat_checked][0] -= dice_commited - 1
	rolling_dice = []
	for i in dice_commited:
		add_rolling_die()
	dice_commited = 0
	
func add_rolling_die():
	if rolling_dice.size() >= 6:
		return null
	# value rolled, time to roll
	var die = [rng.randi_range(1,6), rng.randf_range(2.0,3.0)]
	#var die = [6, 1]
	rolling_dice.append(die)
	play_sound("sounds/dice.wav", 3.0-die[1])
	return die
	
func action_close_alert():
	get_node("/root/Alert").fade_dir = -1
	
func action_equip():
	equipment.append(current_card)
	if "bonus" in current_card:
		var stat_key = current_card["bonus"][0]
		var stat_amount = current_card["bonus"][1]
		stats[stat_key][0] += stat_amount
		stats[stat_key][1] += stat_amount
	add_event("alert", ["Equipped!"])
	
func action_stats():
	change_scene("scenes/StatsMenu.tscn")
	
func action_gear():
	change_scene("scenes/GearMenu.tscn")
	
func action_close():
	change_scene("scenes/Map.tscn")
	
func action_end_stat_check():
	rolling_dice = []
	dice_commited = 1
	get_node("/root/SkillCheck").queue_free()
	#if Globals.check_result_successful:
	#	Globals.card_result(Globals.check_win)
	#else:
	#	Globals.card_result(Globals.check_lose)
	#add_event("change_scene",["scenes/DrawCards.tscn"])


func process_sounds():
	var next_sounds = []
	for sound in sounds:
		if not sound.playing:
			sound.queue_free()
		else:
			next_sounds.append(sound)
	sounds = next_sounds
			

func _process(delta):
	process_sounds()
	if wait_for_alert():
		return
	if process_event():
		return
	if walk_path:
		walk_path["progress"] += travel_speed * delta
		if walk_path["progress"] > walk_path["length"]:
			current_point = walk_path["end"]
			current_point_location = current_point.location_name
			walk_path = null
			destination = null
			
func process_event():
	if not events:
		return
	if has_node("/root/SkillCheck"):
		return
	var next_event = events.pop_front()
	print("processing event:", next_event[0], " ", next_event[1])
	callv(next_event[0], next_event[1])

func alert(message):
	print("Alert:", message)
	if _alert > 0:
		events.append(["alert", [message]])
		return
	_alert = 1
	var alert_scene = ResourceLoader.load("scenes/Alert.tscn").instance()
	alert_scene.get_node("Control/Label").text = message
	get_viewport().add_child(alert_scene)
	
func wait_for_alert():
	if _alert > 0:
		if get_node_or_null("/root/Alert"):
			_alert += 1
		else:
			if _alert > 1:
				_alert = 0
		return true
	else:
		get_tree().paused = false
		
func change_scene(scene_path, force=false):
	if force:
		_change_scene(scene_path)
		return
	add_event("_change_scene", [scene_path])

func _change_scene(scene_path):
	over_list = []
	handlers = []
	current_point = null
	destination = null
	print(current_deck)
	print("change scene to", scene_path)
	get_tree().change_scene(scene_path)
	
func load_deck_at(point_name):
	if not point_name in cards:
		alert("Nothing here")
		return
	return cards[point_name]

func shuffle_decks():
	randomize()
	for key in cards:
		cards[key].shuffle()
		
func new_game():
	_won = 0
	_alert = 0
	current_point_location = "Green Coast"
	cards = config.get("cards").duplicate(true)
	stats = {
		"guile": [3, 3],
		"power": [3, 3],
		"speed": [3, 3],
		"lore": [3, 3]
	}
	gp = 2
	hp = 3
	equipment = []
	shuffle_decks()

func save_game():
	var save_file = File.new()
	save_file.open("user://file1.save", File.WRITE)
	var save_dict = {}
	for key in save_keys:
		save_dict[key] = get(key)
	save_file.store_line(to_json(save_dict))

func load_game():
	var fn = "user://file1.save"
	var save_file = File.new()
	if not save_file.file_exists(fn):
		return false
	save_file.open(fn, File.READ)
	while save_file.get_position() < save_file.get_len():
		var save_dict = parse_json(save_file.get_line())
		for key in save_keys:
			if key in save_dict:
				set(key, save_dict[key])
	return true
