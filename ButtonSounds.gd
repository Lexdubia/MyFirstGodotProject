extends Node

@onready var hover_sound = AudioStreamPlayer.new()
@onready var click_sound = AudioStreamPlayer.new()

func _ready():
	# Añadir los AudioStreamPlayer al árbol
	add_child(hover_sound)
	add_child(click_sound)
		
	# Cargar sonidos (reemplaza con tus archivos de sonido)
	hover_sound.stream = load("res://sounds/hover.wav")
	click_sound.stream = load("res://sounds/click.wav")
	# Conectar todos los botones en el juego al iniciar
	for button in get_tree().get_nodes_in_group("menu_buttons"):
		_connect_button(button)
		
	# Detectar si se añaden nuevos botones después
	get_tree().node_added.connect(_on_node_added)
	
func _connect_button(button):
		button.mouse_entered.connect(on_button_hovered.bind(button))
		button.pressed.connect(_on_button_pressed.bind(button))
		
func _on_node_added(node):
	if node is Button and "menu_buttons" in node.get_groups():
		_connect_button(node)	
		
func on_button_hovered(button):
	hover_sound.play()

func _on_button_pressed(button):
	click_sound.play()
