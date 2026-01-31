extends Node

@export var playerStatus : PlayerStatus

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("silence") \
		and playerStatus.currentMask != PlayerMaskEnum.Value.SILENCE:
		playerStatus.currentMask = PlayerMaskEnum.Value.SILENCE
		get_tree().create_timer(1.5).timeout.connect(reset_mask)

func reset_mask() -> void:
	playerStatus.currentMask = PlayerMaskEnum.Value.NONE
