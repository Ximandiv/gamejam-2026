extends Area2D

@export var bounceDistance := 100.0
@export var bounceDelay := 0.3
@export var playerStatus : PlayerStatus
@export var audioPlayer : AudioStreamPlayer2D

var player_inside : Node2D = null

func _ready() -> void:
	body_entered.connect(_on_player_enter)
	body_exited.connect(_on_player_exit)

func _process(_delta: float) -> void:
	# Si el jugador está dentro y pierde la máscara, expulsarlo
	if player_inside and playerStatus:
		if playerStatus.currentMask == PlayerMaskEnum.Value.NONE:
			print("BounceTrigger: Mask expired while inside, ejecting player!")
			_eject_player()

func _on_player_exit(body: Node2D) -> void:
	if body == player_inside:
		player_inside = null
		print("BounceTrigger: Player exited")

func _on_player_enter(body : Node2D) -> void:
	print("BounceTrigger: Body entered - ", body.name)
	if not body.is_in_group("player"):
		print("BounceTrigger: Not in player group")
		return

	if not playerStatus:
		push_error("BounceTrigger: playerStatus is not assigned!")
		return

	print("BounceTrigger: Player detected! Current mask: ", playerStatus.currentMask)

	# Si tiene una máscara activa (no NONE), dejar pasar y apagar sonido
	if playerStatus.currentMask != PlayerMaskEnum.Value.NONE:
		print("BounceTrigger: Player has mask, letting through and stopping sound")
		player_inside = body
		return

	# Si no tiene máscara, aplicar rebote
	print("BounceTrigger: No mask, applying bounce")
	# Detectar dirección desde donde viene el jugador
	var direction_x = sign(body.global_position.x - global_position.x)
	var direction_y = sign(body.global_position.y - global_position.y)

	var push_strength = bounceDistance / 100.0

	print("BounceTrigger: Direction X=", direction_x, " Y=", direction_y, " Strength=", push_strength)

	# Si viene desde arriba, rebotar hacia arriba y empujar horizontalmente
	if direction_y < 0:
		print("BounceTrigger: Bouncing up and pushing horizontally!")
		body.stopMoving.emit()
		body.pushVertical.emit(push_strength)
		if direction_x == 0:
			direction_x = -1  # Default a izquierda si está exactamente encima
		body.push.emit(int(direction_x), push_strength)
		body.resumeMove.emit()
	else:
		# Si viene desde los lados, empujar horizontalmente
		if direction_x == 0:
			direction_x = -1  # Default a izquierda

		print("BounceTrigger: Stopping movement")
		body.stopMoving.emit()
		await get_tree().create_timer(bounceDelay).timeout
		print("BounceTrigger: Pushing")
		body.push.emit(int(direction_x), push_strength)
		print("BounceTrigger: Resuming movement")
		body.resumeMove.emit()

func _eject_player() -> void:
	if not player_inside:
		return

	# Reactivar el sonido
	if audioPlayer and not audioPlayer.playing:
		audioPlayer.play()

	# Detectar dirección para expulsar
	var direction_x = sign(player_inside.global_position.x - global_position.x)
	if direction_x == 0:
		direction_x = -1

	var push_strength = bounceDistance / 100.0

	print("BounceTrigger: Ejecting player to direction: ", direction_x)
	player_inside.stopMoving.emit()
	player_inside.push.emit(int(direction_x), push_strength * 1.5)  # Empuje más fuerte al expulsar
	player_inside.resumeMove.emit()

	player_inside = null
