extends Node

@export var playerStatus : PlayerStatus

func get_key(key : PlayerKeysEnum.Value):
	if key == PlayerKeysEnum.Value.BEDROOM \
		and !playerStatus.keyList.has(key):
			playerStatus.keyList.append(key)
