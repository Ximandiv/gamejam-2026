extends Node

@export var playerStatus : PlayerStatus
@export var maskDuration : float = 5.0
@export var timerLabel : Label
@export var maskNameLabel : Label
@export var dialogBox : Control

var mask_time_remaining : float = 0.0
var _first_mask_collected : bool = false

signal mask_activated(mask_type: PlayerMaskEnum.Value)
signal mask_deactivated(mask_type: PlayerMaskEnum.Value)

func _ready() -> void:
	# Resetear el estado de la máscara al iniciar
	print("MaskHandler: _ready() called")
	print("MaskHandler: playerStatus = ", playerStatus)
	if playerStatus:
		print("MaskHandler: Current mask before reset: ", playerStatus.currentMask)
		playerStatus.currentMask = PlayerMaskEnum.Value.NONE
		playerStatus.hasSilenceMask = false
		print("MaskHandler: Reset mask to NONE on start")
	else:
		print("MaskHandler: ERROR - playerStatus is null!")

func _process(delta: float) -> void:
	# Actualizar contador de tiempo
	if playerStatus.currentMask != PlayerMaskEnum.Value.NONE:
		mask_time_remaining -= delta
		if mask_time_remaining < 0:
			mask_time_remaining = 0

		# Actualizar labels si existen
		if timerLabel:
			timerLabel.visible = true
			timerLabel.text = "%.1f s" % mask_time_remaining

		if maskNameLabel:
			maskNameLabel.visible = true
			var mask_name = get_mask_name(playerStatus.currentMask)
			maskNameLabel.text = mask_name
	else:
		# Ocultar labels cuando no hay máscara activa
		if timerLabel:
			timerLabel.visible = false
		if maskNameLabel:
			maskNameLabel.visible = false

	if Input.is_action_just_pressed("silence") \
		and playerStatus.hasSilenceMask \
		and playerStatus.currentMask == PlayerMaskEnum.Value.NONE:
		activate_mask(PlayerMaskEnum.Value.SILENCE)

func get_mask(mask : PlayerMaskEnum.Value):
	print("get_mask called with: ", mask)
	print("playerStatus: ", playerStatus)
	if not playerStatus:
		push_error("playerStatus is null!")
		return

	print("Current mask value: ", playerStatus.currentMask)

	if mask == PlayerMaskEnum.Value.SILENCE:
		if !playerStatus.hasSilenceMask:
			playerStatus.hasSilenceMask = true
			print("Silence mask unlocked!")

			# Mostrar diálogo tutorial la primera vez
			print("_first_mask_collected: ", _first_mask_collected)
			print("dialogBox: ", dialogBox)
			if !_first_mask_collected and dialogBox:
				_first_mask_collected = true
				print("Showing dialog now!")
				dialogBox.show_dialog("To use the Silence mask press 1", 36)
			else:
				print("Dialog NOT shown - first_collected:", _first_mask_collected, " dialogBox:", dialogBox)

		# Activar la máscara inmediatamente al recogerla
		#print("Checking if can activate: currentMask=", playerStatus.currentMask, " NONE=", PlayerMaskEnum.Value.NONE)
		#if playerStatus.currentMask == PlayerMaskEnum.Value.NONE:
			#print("Activating mask now!")
			#activate_mask(mask)
		#else:
			#print("Cannot activate, mask already active")

func activate_mask(mask : PlayerMaskEnum.Value):
	playerStatus.currentMask = mask
	mask_time_remaining = maskDuration
	print("Mask activated: ", mask, " for ", maskDuration, " seconds")
	mask_activated.emit(mask)
	get_tree().create_timer(maskDuration).timeout.connect(reset_mask)

func reset_mask() -> void:
	var previous_mask = playerStatus.currentMask
	print("Mask expired, resetting to NONE")
	playerStatus.currentMask = PlayerMaskEnum.Value.NONE
	mask_deactivated.emit(previous_mask)

func get_mask_name(mask_type: PlayerMaskEnum.Value) -> String:
	match mask_type:
		PlayerMaskEnum.Value.NONE:
			return "No Mask"
		PlayerMaskEnum.Value.SILENCE:
			return "SILENCE"
		PlayerMaskEnum.Value.FOCUS:
			return "FOCUS"
		PlayerMaskEnum.Value.BRAVERY:
			return "BRAVERY"
		_:
			return "Unknown"
