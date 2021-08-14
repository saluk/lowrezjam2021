extends Node2D

func _ready():
	var x = 0
	var y = 0
	var image_button = ResourceLoader.load("scenes/ImageButton.tscn")
	var shown = []
	for gear in Globals.equipment:
		if "rollmod" in gear and gear["rollmod"][0] == Globals.stat_checked:
			shown.append(gear)
		if "bonus" in gear and gear["bonus"][0] == Globals.stat_checked:
			shown.append(gear)
		if "recover" in gear and gear["recover"][0] == Globals.stat_checked:
			shown.append(gear)
		if "shield" in gear:
			shown.append(gear) #Should check if we're about to be attacked
	for gear in shown:
		var button = image_button.instance()
		add_child(button)
		button.position.x = x
		button.position.y = y
		x += 9
		if x > 30:
			x = 0
			y += 9
		button.button_action = ""
		button.hover_description = Globals.gear_description(gear)
		button.set_icon(gear["icon"])
		button.node_text_path = "/root/SkillCheck/Interface/Control/InfoBox/Label"
		button.use_info_box = true
