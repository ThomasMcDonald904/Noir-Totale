extends Control


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://MajorScenes/starting_menu.tscn")
