extends Area2D

@export var bounceDistance := 100.0
@export var bounceDelay := 0.3

func _ready() -> void:
	body_entered.connect(_on_player_enter)

func _on_player_enter(body : Node2D) -> void:
	if not body.is_in_group("player"):
		return

	# Detectar dirección desde donde viene el jugador
	var direction_x = sign(body.global_position.x - global_position.x)
	var direction_y = sign(body.global_position.y - global_position.y)

	# Si está exactamente encima (dirección horizontal = 0), usar dirección vertical
	if direction_x == 0:
		direction_x = -1  # Default a izquierda

	var push_strength = bounceDistance / 100.0

	# Si viene desde arriba, aplicar rebote inmediato
	if direction_y < 0:
		body.apply_push_2d(int(direction_x), int(direction_y), push_strength)
	else:
		# Si viene desde los lados, usar delay
		body.stop_movement()
		await get_tree().create_timer(bounceDelay).timeout
		body.apply_push(int(direction_x), push_strength)
		body.resume_movement()
