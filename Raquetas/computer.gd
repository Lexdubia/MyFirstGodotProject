class_name Computer extends CharacterBody2D

@export var acceleration: float = 1000  # Aceleración de la pala
@export var deceleration: float = 500  # Desaceleración de la pala
@export var speed = 350
@export var reaction_time: float = 0.2  # Retraso en la reacción
@export var prediction_strength: float = 0.6  # Qué tan bien predice la trayectoria

var ball
var target_y: float = 0.0
var reaction_timer: float = 0.0

func _ready():
	ball = get_parent().get_node("Ball")

func _physics_process(delta):
	reaction_timer -= delta
	if reaction_timer <= 0:
		reaction_timer = reaction_time  # Simula el tiempo de reacción
		calculate_target_y()
	
	move_paddle(delta)

func calculate_target_y():
	# Predice la posición futura de la bola usando su velocidad
	var future_position = ball.position.y + (ball.velocity.y * prediction_strength)
	target_y = clamp(future_position, 50, get_viewport_rect().size.y - 50)

func move_paddle(delta):
	if abs(target_y - position.y) < 40:
		return
	
	if target_y < position.y:
		velocity.y = -speed
	else:
		velocity.y = speed

	move_and_collide(velocity * delta)
