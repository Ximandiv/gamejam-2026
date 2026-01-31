extends Area2D

@export var keyToOpen : PlayerKeysEnum.Value
@export var playerStatus : PlayerStatus
@export var moveTo : Node2D
@export var speed: float = 200.0
@export_file_path("*.tscn") var nextScenePath : String

var moving := false
var finishedMoving := false
var transitioning := false

func _ready() -> void:
	body_entered.connect(on_open)

func _process(delta: float) -> void:
	if not moving \
		or finishedMoving:
		return
	
	var target := moveTo.global_position
	var step := speed * delta

	if global_position.distance_to(target) <= step:
		global_position = target
		moving = false
		finishedMoving = true
		moveTo.queue_free()
	else:
		global_position = global_position.move_toward(target, step)

func on_open(body : Node2D):
	if body.name != "player" \
		or !playerStatus.keyList.has(keyToOpen) \
		or moving or transitioning:
		return
	
	if moveTo == null:
		change_scene()
		return
	
	moving = true

func change_scene() -> void:
	if transitioning:
		return
	
	transitioning = true
	get_tree().change_scene_to_file(nextScenePath)
	queue_free()
