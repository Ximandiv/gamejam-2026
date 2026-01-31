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
	if body.name != "player":
		return
	
	if playerStatus.currentMask != PlayerMaskEnum.Value.SILENCE:
		body.stop_movement()
		await get_tree().create_timer(1.5).timeout
		body.apply_push(horizontalDirection, pushStrength)
		body.resume_movement()
		return
