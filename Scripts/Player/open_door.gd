extends Area2D

@export var keyToOpen : PlayerKeysEnum.Value
@export var playerStatus : PlayerStatus
@export_file_path("*.tscn") var nextScenePath : String

func _ready() -> void:
	body_entered.connect(on_open)

func on_open(body : Node2D):
	if body.name == "player" \
		and nextScenePath != null:
		change_scene()
	
	if body.name != "player" \
		or !playerStatus.keyList.has(keyToOpen):
		return

func change_scene() -> void:
	get_tree().change_scene_to_file(nextScenePath)
	queue_free()
