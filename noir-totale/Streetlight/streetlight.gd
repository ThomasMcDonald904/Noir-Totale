extends Node3D

var is_blacked_out = false

func blackout():
	$SpotLight3D.light_energy = 0
	is_blacked_out = true
