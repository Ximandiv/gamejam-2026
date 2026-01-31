extends Node

@export var playerStatus : PlayerStatus

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("silence") \
		and playerStatus.hasSilenceMask \
		and playerStatus.currentMask == PlayerMaskEnum.Value.NONE:
		playerStatus.currentMask = PlayerMaskEnum.Value.SILENCE
		get_tree().create_timer(1.5).timeout.connect(reset_mask)

func get_mask(mask : PlayerMaskEnum.Value):
	if mask == PlayerMaskEnum.Value.SILENCE \
		and !playerStatus.hasSilenceMask:
			playerStatus.hasSilenceMask = true

func reset_mask() -> void:
	playerStatus.currentMask = PlayerMaskEnum.Value.NONE
