extends Node2D

export var spire_center = Vector2(32, 50)
export var max_y = 4
export var max_x = 4


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var node = get_child(0).get_child(0)
	while node:
		node.position.x = (global_position.x - spire_center.x)*0.2
		if node.position.x < -max_x:
			node.position.x = -max_x
		if node.position.x > max_x:
			node.position.x = max_x
		node.position.y = (global_position.y - spire_center.y)*0.2
		if node.position.y < -max_y:
			node.position.y = -max_y
		if node.position.y > max_y:
			node.position.y = max_y
		if node.get_child_count() > 0:
			node = node.get_child(0)
		else:
			node = null
