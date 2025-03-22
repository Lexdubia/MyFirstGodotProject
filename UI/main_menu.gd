class_name MainMenu extends Control


func _on_comenzar_pressed() -> void:
	get_tree().change_scene_to_file("res://Game/pong.tscn")
	pass # Replace with function body.




func _on_salir_pressed() -> void:
	get_tree().quit()
