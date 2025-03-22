extends CharacterBody2D

@export var speed = 700
@export var bounce_factor: float = 1.05
@export var max_speed = 900

@onready var hit_player = $hit_player
@onready var hit_computer = $hit_computer
@onready var hit_bounce: AudioStreamPlayer2D = $hit_bounce
@onready var camera: Camera2D = $"../Camera2D"  # Asegúrate de que la ruta sea correcta
@onready var particles: CPUParticles2D = $Particles  # Asegúrate de que el nodo se llama "Particles"

var is_game_over = false
var shake_intensity: float = 3.0  # Intensidad del sacudida
var shake_duration: float = 0.1  # Duración del sacudida en segundos

func _ready() -> void:
	particles.emitting = false  # Desactiva las partículas al inicio

func reset_ball() -> void:
	if !is_game_over:
		var angles = [45, 40, 135, 130, -45, -50, -135, -140]
		var angle = deg_to_rad(angles.pick_random())
		var direction = Vector2(cos(angle), sin(angle)).normalized()
		velocity = direction * speed
		particles.emitting = true  # Activa las partículas al reiniciar la bola

func _physics_process(delta: float) -> void:
	if !is_game_over:
		var collision_info = move_and_collide(velocity * delta)
		if collision_info:
			velocity = velocity.bounce(collision_info.get_normal())
			var collider = collision_info.get_collider()
			if collider is Player:
				hit_player.play()
				shake_camera()  # Sacudir la cámara cuando el jugador golpea la bola
			elif collider is Computer:
				hit_computer.play()
				shake_camera()  # Sacudir la cámara cuando la computadora golpea la bola
			else:
				hit_bounce.play()
				adjust_angle()

func adjust_angle() -> void:
	var angle_in_x = velocity.x
	var angle_change = 5
	var angle = velocity.angle()
	var new_angle = angle
	if angle_in_x > 0:
		new_angle += deg_to_rad(angle_change)
	elif angle_in_x < 0:
		new_angle -= deg_to_rad(angle_change)
	var new_direction = Vector2(cos(new_angle), sin(new_angle)).normalized()
	velocity = new_direction * speed

func shake_camera() -> void:
	if camera:
		var initial_offset = camera.offset  # Guarda la posición original de la cámara
		var timer = 0.0
		
		# Mueve la cámara aleatoriamente durante un breve período
		while timer < shake_duration:
			camera.offset = initial_offset + Vector2(randf_range(-shake_intensity, shake_intensity), randf_range(-shake_intensity, shake_intensity))
			await get_tree().create_timer(0.01).timeout  # Espera un frame
			timer += 0.01
		camera.offset = initial_offset  # Restaura la posición original de la cámara
