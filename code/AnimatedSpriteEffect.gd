extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.connect("animation_finished", self, "end")
	$AnimatedSprite.play()


func end():
	queue_free()
