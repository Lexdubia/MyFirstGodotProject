extends Node

const MAX_SCORE = 9  # Puntos necesarios para ganar

@onready var victory_label: Label = $"../Control/VictoryLabel"
@onready var win_sound: AudioStreamPlayer = $"../WinSound"
@onready var lose_sound: AudioStreamPlayer = $"../LoseSound"
const MAIN_MENU = preload("res://UI/main_menu.tscn")

var player_score: int = 0
var computer_score: int = 0

func _ready() -> void:
	victory_label.hide()  # Asegura que el mensaje de victoria esté oculto al inicio.

func on_goal_scored(is_player: bool) -> void:
	if is_player:
		player_score += 1
		$"../Control/PlayerScore".text = str(player_score)
	else:
		computer_score += 1
		$"../Control/ComputerScore".text = str(computer_score)
	
	check_victory()
	
func check_victory() -> void:
	if player_score >= MAX_SCORE:
		end_game("¡Has ganado!", win_sound)
	elif computer_score >= MAX_SCORE:
		end_game("¡Has perdido!", lose_sound)
	else:
		$"../Ball".call("reset_ball")  # Reinicia la bola en cada punto
		
func end_game(message: String, sound: AudioStreamPlayer) -> void:
	victory_label.text = message
	victory_label.show()
	sound.play()
	$"../Ball".is_game_over = true  # Detener la bola
	await sound.finished
	await get_tree().create_timer(1.0).timeout
	
	get_tree().paused = false  # Asegurarse de que el juego no esté en pausa
	get_tree().change_scene_to_file("res://UI/main_menu.tscn")
