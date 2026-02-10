extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_bat_starved() -> void:
	var bat: CharacterBody3D = get_node("Bat")
	var nest_marker := $NestMarker
	bat.move_camera(bat.CameraPos.AERIAL)
	var tween = get_tree().create_tween()
	tween.tween_property(bat, "global_position", Vector3(bat.global_position.x, 9, bat.global_position.z), 2)
	tween.tween_property(bat, "global_position", nest_marker.global_position, 9)
	
	var dir_2d := Vector2(
		nest_marker.global_position.x - bat.global_position.x,
		nest_marker.global_position.z - bat.global_position.z
	)
	var target_yaw := atan2(dir_2d.x, dir_2d.y) + PI
	
	tween.parallel().tween_property(bat, "rotation:y", target_yaw, 3).set_trans(Tween.TRANS_CIRC)
	tween.parallel().tween_callback($AnimationPlayer.play.bind("fade_to_new"))


func _on_proceder_pressed() -> void:
	get_tree().change_scene_to_file("res://MajorScenes/no_light_world.tscn")
