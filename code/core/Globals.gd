extends Node

export var travel_speed = 10 # 2
export var distance_to_travel_per_speed = 5

var mouse_over
var icon_count = 0
var over_list = []

var handlers = []

var save_keys = ["current_point_location", "cards", "stats"]

var current_point_location = "Green Coast" # save
var cards = {} # save
var stats = {} # save
var equipment = {} # save
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

var events = []

func _init():
	new_game()

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	shuffle_decks()

func get_player_pos():
	if not walk_path and current_point:
		return current_point.position + Vector2(6, 2)
	if not walk_path:
		return null
	var dir = walk_path["end"].position - walk_path["start"].position
	var prog_vec = dir.normalized() * walk_path["progress"]
	return walk_path["start"].position + prog_vec

func _input(ev):
	if wait_for_alert():
		return
	if ev is InputEventMouseButton:
		if ev.pressed:
			if over_list and over_list[-1].has_method("_clicked"):
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
	get_node("/root/Node2D/Interface/Control/MouseCursor").set_cursor(over.icon)
	
func clear_mouse_over(over):
	mouse_over = null
	if not over in over_list:
		return
	if over.has_method("_mouse_exit"):
		over._mouse_exit()
	over_list.erase(over)
	if over_list:
		get_node("/root/Node2D/Interface/Control/MouseCursor").set_cursor(over_list[-1].icon)
	else:
		get_node("/root/Node2D/Interface/Control/MouseCursor").set_cursor("normal")

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

# can we walk to the destination from our current point
func can_walk():
	var max_dist = stats["speed"][1]
	var dist = get_distance()
	if get_distance() < 0:
		return false
	if dist > max_dist:
		return false
	return true

func safe_call(object, method):
	if object.has_method(method):
		object.call(method)

func action_new_game():
	new_game()
	change_scene("res://scenes/Map.tscn")
	
func action_load_game():
	load_game()
	change_scene("res://scenes/Map.tscn")
	
func action_quit_game():
	get_viewport().queue_free()
	
func action_walk():
	walk_path = {
		"start":current_point,
		"end":destination,
		"length":(destination.position-current_point.position).length(),
		"progress":0.0
	}
	
func action_enter():
	load_card_at(current_point_location)
	
func action_close_card():
	change_scene("res://scenes/Map.tscn")
	save_game()
	
func action_equip():
	equipment.append(current_card)
	var stat_key = current_card["bonus"][0]
	var stat_amount = current_card["bonus"][1]
	stats[stat_key][0] += stat_amount
	stats[stat_key][1] += stat_amount
	events.append(["alert", ["Equipped!"]])
	action_close_card()
	
func action_stats():
	change_scene("scenes/StatsMenu.tscn")
	
func action_close():
	change_scene("scenes/Map.tscn")
	
func _process(delta):
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
			#alert("Arrived")
			events.append(["load_card_at", [current_point_location]])
			
func process_event():
	if not events:
		return
	var next_event = events.pop_back()
	callv(next_event[0], next_event[1])

func alert(message):
	var alert_scene = ResourceLoader.load("scenes/Alert.tscn").instance()
	alert_scene.get_node("Control/Label").text = message
	get_viewport().add_child(alert_scene)
	
func wait_for_alert():
	if get_node_or_null("/root/Alert"):
		return true
	else:
		get_tree().paused = false
		
func change_scene(scene_path):
	over_list = []
	handlers = []
	current_point = null
	destination = null
	get_tree().change_scene_to(ResourceLoader.load(scene_path))
	
func load_card_at(point_name):
	if not point_name in cards:
		return
	var card_stack = cards[point_name]
	if card_stack:
		var current_card_index = card_stack.pop_front()
		current_card = card_templates[current_card_index]
	else:
		current_card = {
			"name":"Nothing Here",
			"art":[], 
			"actions":[
				{"name":"Ok","actions":["close_card"]}
			]
		}
	change_scene("res://scenes/Card.tscn")
		
var card_templates = [
	{"name":"Shop", "art":["bazaar"], "actions":[
			{"name":"Haggle", "actions":[]},
			{"name":"Leave", "actions":["close_card"]}
	]},
	{"name":"Alley", "art":["alley"], "actions":[
			{"name":"Search", "actions":[]},
			{"name":"Pass", "actions":["close_card"]}
	]},
	{"name":"Rune Found", "art":["alley"], "actions":[
		{"name":"Start Over", "actions":["new_game"]},
		{"name":"Quit", "actions":["quit_game"]}
	]},
	{"name":"Boots (spd+1)", "art":[], "actions": [
		{"name":"Equip", "actions":["equip"]},
		{"name":"Discard", "actions":["close_card"]} 
	], "bonus":["speed",1]}
]

func shuffle_decks():
	randomize()
	for key in cards:
		cards[key].shuffle()
		
func new_game():
	current_point_location = "Green Coast"
	cards = {
		"Green Coast": [3],
		"Tree of Wealth": [1],
		"Coal City": [0, 0, 0, 0],
		"Deep Pit": [1, 1, 1, 0],
		"Fairway Inn": []
	}
	stats = {
		"guile": [3, 3],
		"power": [3, 3],
		"speed": [3, 3],
		"lore": [3, 3]
	}
	equipment = []

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
