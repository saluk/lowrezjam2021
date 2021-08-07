extends Node2D
var frames = 0.0
var fps = 5.0/60.0
var rot_speed = 960
var rolling = true

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_number(num):
	$AnimatedSprite.frame = num-1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $AnimatedSprite.rotation_degrees > 360:
		$AnimatedSprite.rotation_degrees -= 360
	if $AnimatedSprite.rotation_degrees < 0:
		$AnimatedSprite.rotation_degrees += 360
	if rolling:
		frames += delta
		if frames > fps:
			frames = 0.0
			set_number(rand_range(1,6))
		$AnimatedSprite.rotation_degrees += rot_speed*delta
		$AnimatedSprite.position.x += rand_range(-1,1)
		$AnimatedSprite.position.x = clamp($AnimatedSprite.position.x,-2.0,2.0)
	else:
		#if $AnimatedSprite.rotation_degrees > 0:
		#	$AnimatedSprite.rotation_degrees -= 360 * delta
		#	if $AnimatedSprite.rotation_degrees < 0:
		#		$AnimatedSprite.rotation_degrees = 0
		if $AnimatedSprite.rotation_degrees < 360:
			$AnimatedSprite.rotation_degrees += 360 * delta
			if $AnimatedSprite.rotation_degrees > 360:
				$AnimatedSprite.rotation_degrees = 360
