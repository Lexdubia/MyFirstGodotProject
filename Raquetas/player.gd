class_name Player extends CharacterBody2D

@export var max_speed: float = 500  # Velocidad máxima
@export var acceleration: float = 800  # Qué tan rápido acelera
@export var friction: float = 5000  # Qué tan rápido desacelera

func _physics_process(delta):
	var direction = 0
	
	# Detecta la dirección de movimiento
	if Input.is_action_pressed("ui_up"):
		direction = -1
	elif Input.is_action_pressed("ui_down"):
		direction = 1
	
	# Acelera si se está moviendo, desacelera si no
	if direction != 0:
		velocity.y = move_toward(velocity.y, direction * max_speed, acceleration * delta)
	else:
		velocity.y = move_toward(velocity.y, 0, friction * delta)
	
	# Aplica el movimiento
	move_and_collide(velocity * delta)
