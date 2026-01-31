extends Node2D

signal receiveMask(mask : PlayerMaskEnum.Value)
signal stopMoving
signal resumeMove
signal push(direction: int, strength: float)
signal stopPush

func _ready() -> void:
	stopMoving.connect($Movement.stop_movement)
	resumeMove.connect($Movement.resume_movement)
	push.connect($Movement.apply_push)
	stopPush.connect($Movement.stop_push)
	receiveMask.connect(get_mask)

func get_mask(mask : PlayerMaskEnum.Value):
	$MaskHandler.get_mask(mask)
