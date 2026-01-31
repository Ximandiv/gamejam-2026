extends Node2D

@export var playerStatus : PlayerStatus

signal receiveMask(mask : PlayerMaskEnum.Value)
signal receiveKey(key : PlayerKeysEnum.Value)

signal stopMoving
signal resumeMove
signal push(direction: int, strength: float)
signal pushVertical(strength: float)
signal stopPush

func _enter_tree() -> void:
	add_to_group("player")

func _ready() -> void:
	stopMoving.connect($Movement.stop_movement)
	resumeMove.connect($Movement.resume_movement)
	push.connect($Movement.apply_push)
	pushVertical.connect($Movement.apply_push_vertical)
	stopPush.connect($Movement.stop_push)
	receiveMask.connect($MaskHandler.get_mask)
	receiveKey.connect($KeyHandler.get_key)
