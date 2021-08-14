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
	Globals.change_scene("scenes/SkillCheck.tscn", true)

func action_draw_player_card():
	if self.action.arguments.size() > 0:
		var card_index = self.action.arguments[0]
		Globals.current_card = Globals.get_card_template(card_index)
	Globals.action_equip()

func action_stat_up():
	Globals.stat_up(self.action.arguments[0], self.action.arguments[1])

func action_remove_player_card():
	if not Globals.equipment:
		return
	var i = Globals.rng.randi_range(0, Globals.equipment.size()-1)
	Globals.equipment.remove(i)

func action_modify():
	Globals.modify(self.action.arguments[0], self.action.arguments[1])

func action_buy():
	if self.action.arguments[1] > Globals.gp:
		Globals.last_action_succeeded = false
	Globals.add_next_card(self.action.arguments[0])

func action_clear_status():
	var new_eq = []
	var bad = []
	for e in Globals.equipment:
		if "bad" in e:
			bad.append(e)
			Globals.equip_remove(e)
		else:
			new_eq.append(e)
	Globals.equipment = new_eq
