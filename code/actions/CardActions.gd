extends ActionSet
class_name CardActions

func _init(v).(v):
	pass

func action_add_card_to_stack():
	var card_index = self.action.arguments[0]
	Globals.current_deck.append(Globals.get_card_template(card_index))

func action_check():
	Globals.rolling_dice = []
	Globals.dice_commited = 1
	Globals.stat_checked = self.action.arguments[0]
	Globals.target_number = self.action.arguments[1]
	Globals.check_win = self.action.arguments[2]
	Globals.check_lose = self.action.arguments[3]
	Globals.change_scene("scenes/SkillCheck.tscn")

func action_draw_player_card():
	if self.action.arguments.size() > 0:
		var card_index = self.action.arguments[0]
		Globals.current_card = Globals.get_card_template(card_index)
	Globals.action_equip()
