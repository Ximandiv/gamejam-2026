extends Node2D

@export var soundSource : AudioStreamPlayer2D
@export var normalVolume : float = -10.0
@export var mutedVolume : float = -35.0
@export var fadeSpeed : float = 2.0

var target_volume : float = -10.0

func _ready() -> void:
	print("Level: _ready() called")
	# Conectar a las señales del MaskHandler del jugador
	var player = get_node("player")
	print("Level: Player node: ", player)
	if player:
		var mask_handler = player.get_node("MaskHandler")
		print("Level: MaskHandler node: ", mask_handler)
		if mask_handler:
			mask_handler.mask_activated.connect(_on_mask_activated)
			mask_handler.mask_deactivated.connect(_on_mask_deactivated)
			print("Level: Connected to mask signals successfully!")
		else:
			print("Level: ERROR - MaskHandler not found!")
	else:
		print("Level: ERROR - Player not found!")

	if soundSource:
		target_volume = normalVolume
		soundSource.volume_db = normalVolume
		print("Level: Sound source configured, volume: ", normalVolume)
	else:
		print("Level: ERROR - Sound source not assigned!")

func _process(delta: float) -> void:
	if soundSource:
		# Interpolación suave del volumen
		soundSource.volume_db = lerp(soundSource.volume_db, target_volume, fadeSpeed * delta)

func _on_mask_activated(mask_type: int) -> void:
	print("Level: Mask activated, fading sound to muted")
	if mask_type == PlayerMaskEnum.Value.SILENCE:
		target_volume = mutedVolume

func _on_mask_deactivated(mask_type: int) -> void:
	print("Level: Mask deactivated, fading sound to normal")
	if mask_type == PlayerMaskEnum.Value.SILENCE:
		target_volume = normalVolume
