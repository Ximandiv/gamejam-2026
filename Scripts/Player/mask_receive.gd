extends Area2D

@export var maskToReceive : PlayerMaskEnum.Value = PlayerMaskEnum.Value.SILENCE

var alreadyPicked = false

func _ready() -> void:
	body_entered.connect(give_to_player)

func give_to_player(body : Node2D):
	if body.name != "player" \
		or alreadyPicked:
		return

	alreadyPicked = true
	body.receiveMask.emit(maskToReceive)
	queue_free()
