extends Area2D

@export var keyToOpen : PlayerKeysEnum.Value
@export var playerStatus : PlayerStatus
@export var moveTo : Node2D
@export var speed: float = 200.0

var moving := false
var finished := false

func _ready() -> void:
	body_entered.connect(on_open)

func _process(delta: float) -> void:
	if not moving \
		or finished:
		return
	
	global_position = global_position.move_toward(
		moveTo.global_position,
		speed * delta
	)
	
	if global_position.is_equal_approx(moveTo.global_position):
		moving = false
		finished = true
		moveTo.queue_free()

func on_open(body : Node2D):
	if body.name != "player" \
		or !playerStatus.keyList.has(keyToOpen):
		return
	
	moving = true
