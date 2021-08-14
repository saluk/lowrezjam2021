extends Node2D

func _ready():
	var x = 6
	var y = 20
	for node in $Control/GearIcons.get_children():
		node.queue_free()
	var image_button = ResourceLoader.load("scenes/ImageButton.tscn")
	for gear in Globals.equipment:
		var button = image_button.instance()
		$Control/GearIcons.add_child(button)
		button.position.x = x
		button.position.y = y
		x += 10
		if x > 64-8:
			x = 6
			y += 10
		button.button_action = ""
		button.hover_description = Globals.gear_description(gear)
		button.set_icon(gear["icon"])
		button.node_text_path = "/root/GearMenu/Control/InfoBox/Label"
		button.use_info_box = true
