extends Area2D

# Horizontal Direction is -1 for left, 1 for right
@export var horizontalDirection := -1
@export var pushStrength := 1.0
@export var playerStatus : PlayerStatus

func _enter_tree() -> void:
	add_to_group("sound_push_area")

func _ready() -> void:
	body_entered.connect(_on_player_enter)

func _on_player_enter(body : Node2D) -> void:
	print("Body entered: ", body.name)
	if body.name != "player":
		return

	print("Current mask: ", playerStatus.currentMask)
	if playerStatus.currentMask == PlayerMaskEnum.Value.NONE:
		print("Applying bounce!")
		var movement = body.get_node("Movement")
		print("Movement node: ", movement)
		if movement:
			movement.stopMoving.emit()
			print("Stopped movement")
			await get_tree().create_timer(1.5).timeout
			print("Pushing with direction: ", horizontalDirection, " strength: ", pushStrength)
			movement.push.emit(horizontalDirection, pushStrength)
			movement.resumeMove.emit()
			print("Resumed movement")
		return
