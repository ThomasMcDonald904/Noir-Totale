extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Streetlight.blackout()
	$AnimationPlayer.play("fade_no_light_world")
	$Bat.hunger_rate = 5
