class_name Controller extends Node

const CENTER = Vector2(640, 360)
var player_score:int = 0
var computer_score:int = 0
var paused:bool = false

@onready var pause_menu: PauseMenu = $Pause_menu
@onready var goal_player_sound: AudioStreamPlayer2D = $GoalPlayerSound
@onready var goal_computer_sound: AudioStreamPlayer2D = $GoalComputerSound
@onready var game_manager: Node = $GameManager
@onready var countdown_label: Label = $Control/CountdownLabel  # Añade un Label para mostrar la cuenta atrás
@onready var new_point_label: Label = $Control/NewPointLabel
@onready var ball: CharacterBody2D = $Ball

func _ready() -> void:
	pause_menu.hide()  # Asegura que el menú de pausa no sea visible al inicio
	new_point_label.hide()  # Oculta el Label de "Nuevo punto" al inicio
	start_countdown()  # Inicia la cuenta atrás

func start_countdown():
	countdown_label.show()  # Muestra el Label de la cuenta atrás
	countdown_label.text = "3"  # Comienza con "3"
	await get_tree().create_timer(1.0).timeout  # Espera 1 segundo
	countdown_label.text = "2"  # Cambia a "2"
	await get_tree().create_timer(1.0).timeout  # Espera 1 segundo
	countdown_label.text = "1"  # Cambia a "1"
	await get_tree().create_timer(1.0).timeout  # Espera 1 segundo
	countdown_label.text = "¡GO!"  # Muestra "¡GO!"
	await get_tree().create_timer(0.5).timeout  # Espera medio segundo
	countdown_label.hide()  # Oculta el Label
	reset()  # Comienza el juego

func _on_computer_goal_body_entered(body: Node2D) -> void:
	game_manager.on_goal_scored(false)
	goal_computer_sound.play()  # Reproduce sonido de gol del oponente
	if not ball.is_game_over:  # Verifica si el juego no ha terminado
		show_new_point_message()  # Muestra el mensaje "Nuevo punto"
	await get_tree().create_timer(1.0).timeout  # Espera 1 segundo
	reset()

func _on_player_goal_body_entered(body: Node2D) -> void:
	game_manager.on_goal_scored(true)
	goal_player_sound.play()  # Reproduce sonido de gol del jugador
	if not ball.is_game_over:  # Verifica si el juego no ha terminado
		show_new_point_message()  # Muestra el mensaje "Nuevo punto"
	await get_tree().create_timer(1.0).timeout  # Espera 1 segundo
	reset()

func show_new_point_message():
	new_point_label.text = "¡Nuevo punto!"  # Cambia el texto del Label
	new_point_label.show()  # Muestra el Label
	ball.set_physics_process(false)  # Desactiva el procesamiento de física de la bola
	ball.velocity = Vector2.ZERO
	await get_tree().create_timer(2.0).timeout  # Espera 2 segundos
	new_point_label.hide()  # Oculta el Label

func reset():
	ball.position = CENTER
	ball.call("reset_ball")
	ball.set_physics_process(true)
	$Player.position.y = CENTER.y
	$Computer.position.y = CENTER.y
	
	
func _input(event):
	if event.is_action_pressed("pause"):  # Detecta si se presiona la tecla de pausa
		get_tree().paused = not get_tree().paused  # Alterna entre pausa y reanudar
		if get_tree().paused:
			pause_menu.show()  # Mostrar menú al pausar
		else:
			pause_menu.hide()  # Ocultar menú al reanudar
