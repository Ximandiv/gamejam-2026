extends Node2D

@export var playerStatus : PlayerStatus

signal receiveMask(mask : PlayerMaskEnum.Value)
signal receiveKey(key : PlayerKeysEnum.Value)

signal stopMoving
signal resumeMove
signal push(direction: int, strength: float)
signal stopPush

func _ready() -> void:
	stopMoving.connect($Movement.stop_movement)
	resumeMove.connect($Movement.resume_movement)
	push.connect($Movement.apply_push)
	stopPush.connect($Movement.stop_push)
	receiveMask.connect($MaskHandler.get_mask)
	receiveKey.connect($KeyHandler.get_key)
