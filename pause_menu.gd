class_name PauseMenu extends Control


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS  # Permite que el menú siga funcionando en pausa

func _process(delta: float) -> void:
	pass


func _on_jugar_pressed() -> void:
	get_tree().paused = false  # Despausar el juego
	hide()  # Ocultar el menú de pausa

func _on_menu_pressed() -> void:
	get_tree().paused = false  # Desactivar la pausa antes de cambiar a la escena principal
	get_tree().change_scene_to_file("res://UI/main_menu.tscn")
