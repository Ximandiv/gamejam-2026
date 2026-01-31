extends Area2D

@export var keyToReceive : PlayerKeysEnum.Value

func _ready() -> void:
	body_entered.connect(give_to_player)

func give_to_player(body : Node2D) -> void:
	if body.name != "player":
		return
	
	body.receiveKey.emit(keyToReceive)
	queue_free()
